/*
 * Copyright 2018 balena.io
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

const _ = require('lodash');
const fs = require('fs-extra');
const path = require('path');
const contrato = require('@balena/contrato');
const yaml = require('js-yaml');
const { concurrentForEach } = require('./utils');
const { getSdk } = require('balena-sdk');

const balena = getSdk({
	apiUrl: 'https://api.balena-cloud.com/',
	dataDirectory: false,
});

const workflowFileCreated = [];
function generateWorkflowFile(library, needs = []) {
	// bail out if workflow was already created for this library on this run
	if (workflowFileCreated.indexOf(library) > -1) {
		return;
	}

	const workflow = JSON.parse(JSON.stringify(workflowTemplate));

	function getRandomInt(min, max) {
		min = Math.ceil(min);
		max = Math.floor(max);
		return Math.floor(Math.random() * (max - min + 1)) + min;
	}

	if (needs.length > 0) {
		workflow.on.workflow_run = {
			workflows: needs,
			types: ['completed'],
		};
		delete workflow.on.schedule;
		delete workflow.on.pull_request;
	} else {
		delete workflow.on.workflow_run;
		// generate a random cron definition to avoid ~3k workflows / ~40k jobs queued at once
		// 0-59 minutes, 0-23 hours, 1-7 days of the month (first week)
		const cronDefinition = `${getRandomInt(0, 59)} ${getRandomInt(
			0,
			23,
		)} ${getRandomInt(1, 7)} * *`;
		workflow.on.schedule = [{ cron: cronDefinition }];
	}

	workflow.name = `bake-${library}`;
	workflow.env.LIBRARY = path.join('library', library + '.json');

	const destination = path.join(DEST_DIR, `bake-${library}.yml`);

	fs.writeFileSync(destination, yaml.dump(workflow));
	workflowFileCreated.push(library);
}

const BLUEPRINT_PATHS = {
	'os-arch': path.join(__dirname, 'blueprints/os-arch.yaml'),
	'os-device': path.join(__dirname, 'blueprints/os-device.yaml'),
	'stack-device': path.join(__dirname, 'blueprints/stack-device.yaml'),
	'stack-arch': path.join(__dirname, 'blueprints/stack-arch.yaml'),
};
const CONTRACTS_PATH = path.join(__dirname, 'contracts/contracts');
const DEST_DIR = path.join(__dirname, '../.github/workflows');

const workflowTemplateFile = path.join(__dirname, 'workflows', 'bake.yml');
const workflowTemplate = yaml.load(
	fs.readFileSync(workflowTemplateFile, 'utf8'),
);

// Find and build all contracts from the contracts/ directory
const allContracts = require('require-all')({
	dirname: CONTRACTS_PATH,
	filter: /.json$/,
	recursive: true,
	resolve: (json) => {
		// We only want to process the
		// canonical version of the contract
		const { aliases, ...obj } = json;
		return contrato.Contract.build(obj);
	},
});

const contracts = _.reduce(
	_.values(allContracts),
	(accumulator, value) => {
		return _.concat(
			accumulator,
			_.flattenDeep(_.map(_.values(value), _.values)),
		);
	},
	[],
);

// Create universe of contracts
const universe = new contrato.Contract({
	type: 'meta.universe',
});
universe.addChildren(contracts);

// Remove `resinos` and `balenaos` OS contract since we don't want it for the base images
const resinosChildren = universe.findChildren(
	contrato.Contract.createMatcher({
		type: 'sw.os',
		slug: 'resinos',
	}),
);

const balenaosChildren = universe.findChildren(
	contrato.Contract.createMatcher({
		type: 'sw.os',
		slug: 'balena-os',
	}),
);

resinosChildren.concat(balenaosChildren).forEach((child) => {
	universe.removeChild(child);
});

// Load arguments
const types = process.argv.slice(2);
if (types.length === 0) {
	console.error(`Usage: ${process.argv[0]} ${process.argv[1]} <types...>`);
	process.exit(1);
}

let blueprints = types;

if (types.indexOf('all') > -1) {
	// Generate dockerfile for all blueprints
	blueprints = Object.keys(BLUEPRINT_PATHS);
}

(async () => {
	const supportedDeviceTypes = await balena.models.deviceType.getAllSupported({
		$select: ['name', 'slug'],
	});
	// Remove discontinued device types
	const supportedDeviceFilter = {
		type: 'object',
		properties: {
			slug: {
				type: 'string',
				enum: supportedDeviceTypes.map((device) => device.slug),
			},
		},
	};
	await Promise.all(
		blueprints.map(async (type) => {
			if (!BLUEPRINT_PATHS[type]) {
				console.error(
					`Blueprint for this base images type: ${type} is missing!`,
				);
				process.exit(1);
			}

			const query = yaml.load(await fs.readFile(BLUEPRINT_PATHS[type], 'utf8'));

			if (Object.keys(query.selector).includes('hw.device-type')) {
				query.selector['hw.device-type'] = {
					cardinality: query.selector['hw.device-type'],
					filter: supportedDeviceFilter,
				};
			}

			// Execute query
			const result = contrato.query(
				universe,
				query.selector,
				query.output,
				true,
			);

			// Write output
			await fs.ensureDir(DEST_DIR);

			let count = 0;

			await concurrentForEach(result, 5, async (context) => {
				const json = context.toJSON();

				console.log(`Generating ${json.slug}`);

				const needsLibrary = [];

				if (type === 'os-device' || type === 'stack-arch') {
					needsLibrary.push(
						['bake', json.children.arch.sw.slug, json.children.sw.os.slug].join(
							'-',
						),
					);
				}

				if (type === 'stack-device') {
					needsLibrary.push(
						[
							'bake',
							json.children.hw['device-type'].slug,
							json.children.sw.os.slug,
						].join('-'),
					);
				}

				generateWorkflowFile(json.imageName, needsLibrary);

				count++;
			});

			console.log(
				`Generated ${count} results out of ${
					universe.getChildren().length
				} contracts`,
			);
			console.log(`Adding generated ${count} contracts back to the universe`);
		}),
	);
})();
