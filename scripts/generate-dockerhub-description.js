/*
 * Copyright 2017 balena.io
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

const DEST_DIR = path.join(__dirname, '../balena-base-images');
const BLUEPRINT_PATHS = {
	'os-arch': path.join(
		__dirname,
		'blueprints/dockerhub/os-arch-dockerhub-full-desc.yaml',
	),
	'os-device': path.join(
		__dirname,
		'blueprints/dockerhub/os-device-dockerhub-full-desc.yaml',
	),
	'stack-arch': path.join(
		__dirname,
		'blueprints/dockerhub/stack-arch-dockerhub-full-desc.yaml',
	),
	'stack-device': path.join(
		__dirname,
		'blueprints/dockerhub/stack-device-dockerhub-full-desc.yaml',
	),
};
const CONTRACTS_PATH = path.join(__dirname, 'contracts/contracts');

// Find and build all contracts from the contracts/ directory
const allContracts = require('require-all')({
	dirname: CONTRACTS_PATH,
	filter: /.json$/,
	recursive: true,
	resolve: (json) => {
		return contrato.Contract.build(json);
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
	// Use all blueprints
	blueprints = Object.keys(BLUEPRINT_PATHS);
}

(async () => {
	await Promise.all(
		blueprints.map(async (type) => {
			if (!BLUEPRINT_PATHS[type]) {
				console.error(
					`Blueprint for this base images type: ${type} is missing!`,
				);
				process.exit(1);
			}

			const query = yaml.load(await fs.readFile(BLUEPRINT_PATHS[type], 'utf8'));

			// Execute query
			const result = contrato.query(
				universe,
				query.selector,
				query.output,
				true,
			);

			// Get templates
			const template = query.output.template[0].data;

			// Write output
			await concurrentForEach(result, 5, async (context) => {
				const json = context.toJSON();
				const destination = path.join(DEST_DIR, json.path, json.filename);

				if (!(await fs.pathExists(destination))) {
					console.log(`Generating ${json.imageName}`);
					await fs.outputFile(
						destination,
						await contrato.buildTemplate(template, context, {
							directory: CONTRACTS_PATH,
						}),
					);
				}
			});
		}),
	);
})();
