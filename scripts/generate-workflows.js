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

const workflows = {};
function addToWorkflow(dest, context) {
	const template = JSON.parse(JSON.stringify(workflowTemplate));
	const workflow = _.merge(workflows[dest] || template, context.workflow);

	const prepareJobSlug = `prepare-${context.imageName}`;
	const bakeJobSlug = `bake-${context.imageName}`;

	if (context.workflow.jobs?.prepare) {
		workflow.jobs[prepareJobSlug] = _.merge(
			template.jobs.prepare,
			context.workflow.jobs.prepare,
		);
	}

	if (context.workflow.jobs?.bake) {
		workflow.jobs[bakeJobSlug] = _.merge(
			template.jobs.bake,
			context.workflow.jobs.bake,
		);
		workflow.jobs[
			bakeJobSlug
		].strategy.matrix.target = `\${{ fromJSON(needs.${prepareJobSlug}.outputs.bake-targets) }}`;
	}

	workflows[dest] = workflow;
}

const BLUEPRINT_PATHS = {
	'os-arch': path.join(__dirname, 'blueprints/workflows/os-arch.yaml'),
	'os-device': path.join(__dirname, 'blueprints/workflows/os-device.yaml'),
	'stack-device': path.join(
		__dirname,
		'blueprints/workflows/stack-device.yaml',
	),
	'stack-arch': path.join(__dirname, 'blueprints/workflows/stack-arch.yaml'),
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

				const destination = path.join(DEST_DIR, json.path, json.filename);

				addToWorkflow(destination, json);

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

	const yamlOptions = {
		noRefs: true, // Avoids creating anchors
		lineWidth: 10000, // Set to a very large value to avoid wrapping lines
	};

	// Write workflows to disk
	console.log('Writing workflows to disk');
	for (const [dest, workflow] of Object.entries(workflows)) {
		// delete the template jobs before writing to disk
		delete workflow.jobs.prepare;
		delete workflow.jobs.bake;
		fs.writeFileSync(dest, yaml.dump(workflow, yamlOptions));
	}
})();
