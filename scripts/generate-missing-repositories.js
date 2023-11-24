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

/* eslint-disable @typescript-eslint/no-var-requires */
const _ = require('lodash');
const fs = require('fs-extra');
const path = require('path');
const contrato = require('@balena/contrato');
const yaml = require('js-yaml');
const { concurrentForEach } = require('./utils');
const { getSdk } = require('balena-sdk');
const requireAll = require('require-all');
/* eslint-enable @typescript-eslint/no-var-requires */

const balena = getSdk({
	apiUrl: 'https://api.balena-cloud.com/',
	dataDirectory: false,
});

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
const allContracts = requireAll({
	dirname: CONTRACTS_PATH,
	filter: /.json$/,
	recursive: true,
	resolve: (json) => {
		// We only want to process the
		// canonical version of the contract and no variants
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
	// Use all blueprints
	blueprints = Object.keys(BLUEPRINT_PATHS);
}

void (async () => {
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

	const checkedRepositories = [];
	const missingRepositories = [];

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

			// Function to wait for a specified number of milliseconds
			const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

			async function checkDockerHubRepo(repo, retries = 8, delay = 2000) {
				const url = `https://hub.docker.com/v2/repositories/${repo}/`;
				const user = process.env.DOCKERHUB_USER;
				const token = process.env.DOCKERHUB_TOKEN;

				try {
					const headers = {};

					// If the user and token are provided, add the Authorization header
					if (user && token) {
						headers['Authorization'] = `Bearer ${token}`;
					}

					const response = await fetch(url, {
						method: 'HEAD',
						headers: headers,
					});

					if (response.ok) {
						console.log(`Repository ${repo} exists.`);
						return true;
					} else if (response.status === 404) {
						console.log(`Repository ${repo} does not exist.`);
						return false;
					} else if (response.status === 429 && retries > 0) {
						// If 429 is received, wait for the delay, then retry
						console.log(`Rate limit exceeded. Retrying in ${delay}ms...`);
						await sleep(delay);
						return checkDockerHubRepo(repo, retries - 1, delay * 2); // Exponential backoff
					} else {
						// Other HTTP status codes
						console.error('Failed to check repository: ', response.statusText);
						return false;
					}
				} catch (error) {
					console.error('Error checking repository:', error);
					return false;
				}
			}

			await concurrentForEach(result, 1, async (context) => {
				const json = context.toJSON();
				let repository = path.join(json.namespace, json.imageName);

				if (!checkedRepositories.includes(repository)) {
					if (!(await checkDockerHubRepo(repository))) {
						missingRepositories.push(repository);
					}
					checkedRepositories.push(repository);
				}

				// for debian projects check imageNames without the os suffix
				if (json.children.sw.os.slug === 'debian') {
					repository = path.join(
						json.namespace,
						json.imageName.replace('-debian', ''),
					);
					if (!checkedRepositories.includes(repository)) {
						if (!(await checkDockerHubRepo(repository))) {
							missingRepositories.push(repository);
						}
						checkedRepositories.push(repository);
					}
				}
			});
		}),
	);

	// log any missing repositories to stderr
	if (missingRepositories.length > 0) {
		console.error(
			`The following repositories returned 404 from DockerHub:\n- ${missingRepositories.join(
				'\n- ',
			)}`,
		);
	}
})();
