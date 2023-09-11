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

function yyyymmdd() {
	var now = new Date();
	var y = now.getFullYear();
	var m = now.getMonth() + 1;
	var d = now.getDate();
	return '' + y + (m < 10 ? '0' : '') + m + (d < 10 ? '0' : '') + d;
}

function getVersionAliases(version, latestVersion, generateAllAliases = true) {
	// version can be a full version x.y.z or x.y or just x (only for latest version if generateAllAliases is false).
	const result = [version];

	// x.y (major.minor)
	let versionAlias = version.match('([0-9]*.[0-9]*)');
	if (!result.includes(versionAlias[0])) {
		result.push(versionAlias[0]);
	}

	// x (major)
	versionAlias = version.match('([0-9]*)');
	if (generateAllAliases) {
		if (!result.includes(versionAlias[0])) {
			result.push(versionAlias[0]);
		}
	} else {
		if (version === latestVersion) {
			if (!result.includes(versionAlias[0])) {
				result.push(versionAlias[0]);
			}
		}
	}

	return result;
}

// Generate combinations that contain one element from each of the given arrays
// Inspired by https://www.geeksforgeeks.org/combinations-from-n-arrays-picking-one-element-from-each-array/
function generateCombinations(arr) {
	const combinations = [];

	const n = arr.length;
	// keep track index in each of the n arrays
	const indices = new Array(n).fill(0);

	while (true) {
		let tmp = [];

		// store current combination
		for (var i = 0; i < n; i++) {
			tmp.push(arr[i][indices[i]]);
		}

		combinations.push(tmp.filter((c) => c).join('-'));

		// find the rightmost array that has more element left after the current element
		var next = n - 1;
		while (next >= 0 && indices[next] + 1 >= arr[next].length) {
			next--;
		}

		// no such array is found so no more combinations left
		if (next < 0) {
			break;
		}

		// if next element is found then set the indices for next combination
		indices[next]++;
		for (i = next + 1; i < n; i++) {
			indices[i] = 0;
		}
	}

	return combinations.filter((c) => c);
}

function getPlatform(arch) {
	switch (arch) {
		case 'aarch64':
			return 'linux/arm64';
		case 'amd64':
			return 'linux/amd64';
		case 'armv7hf':
			return 'linux/arm/v7';
		case 'i386':
			return 'linux/386';
		case 'rpi':
			return 'linux/arm/v5';
		default:
			console.error(`Unsupported arch: ${arch}`);
			process.exit(1);
	}
}

function slugify(str) {
	return str
		.toLowerCase()
		.replace(/[^a-z0-9\s]/g, '-')
		.replace(/-+/g, '-');
}

const bakeFileCreated = [];
function generateBakeFile(context, tags) {
	const content = {
		group: {
			default: {
				targets: [slugify(context.slug)],
			},
		},
		target: {
			[slugify(context.slug)]: {
				context: context.path,
				dockerfile: 'Dockerfile',
				platform: getPlatform(context.children.arch.sw.slug),
				tags: tags,
				cache_from: tags,
			},
		},
	};

	const destination = path.join(DEST_DIR, context.imageName + '.json');

	// remove file if it exists and was not created by this run
	if (bakeFileCreated.indexOf(context.imageName) === -1) {
		try {
			fs.unlinkSync(destination);
		} catch (error) {
			// ignore error
		}
	}

	bakeFileCreated.push(context.imageName);

	let existingContent = {};
	try {
		existingContent = JSON.parse(fs.readFileSync(destination, 'utf8'));
	} catch (error) {
		// ignore error
	}

	function customizer(objValue, srcValue) {
		if (_.isArray(objValue)) {
			return objValue.concat(srcValue);
		}
	}

	const mergedData = _.mergeWith(existingContent, content, customizer);

	fs.writeFileSync(destination, JSON.stringify(mergedData, null, 2));
}

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
		workflow.on.workflow_run.workflows = needs;
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

	const destination = path.join(WORKFLOWS_PATH, `bake-${library}.yml`);

	fs.writeFileSync(destination, yaml.dump(workflow));
	workflowFileCreated.push(library);
}

async function generateOsArchLibrary(context) {
	const osVersions = [context.children.sw.os.version];
	if (context.children.sw.os.version === context.children.sw.os.data.latest) {
		osVersions.push('latest');
		osVersions.push(null);
	}

	const variants = [context.children.sw['stack-variant'].slug];
	if (context.children.sw['stack-variant'].slug === 'run') {
		variants.push(null);
	}

	let repo = [[NAMESPACE, context.imageName].join('/')];
	let tags = generateCombinations([osVersions, variants, [yyyymmdd(), null]]);

	// loop over all tags and append the repo as a prefix
	let repoTags = tags.map((tag) => {
		return [repo, tag].join(':');
	});

	// for debian projects create aliases without the os suffix
	if (context.children.sw.os.slug === 'debian') {
		repo = [NAMESPACE, context.imageName.replace('-debian', '')].join('/');
		// loop over all tags and append the repo as a prefix
		repoTags = [
			...repoTags,
			...tags.map((tag) => {
				return [repo, tag].join(':');
			}),
		];
	}

	generateBakeFile(context, repoTags);
}

async function generateStackLibrary(context) {
	let stackVersions = [];
	if (context.children.sw.stack.slug === 'python') {
		// python stack is special since there are some 3.x series supported so do not generate all version aliases for it.
		stackVersions = getVersionAliases(
			context.children.sw.stack.version,
			context.children.sw.stack.data.latest,
			false,
		);
	} else {
		stackVersions = getVersionAliases(
			context.children.sw.stack.version,
			context.children.sw.stack.data.latest,
		);
	}

	if (
		context.children.sw.stack.version === context.children.sw.stack.data.latest
	) {
		stackVersions.push('latest');
		stackVersions.push(null);
	}

	const osVersions = [context.children.sw.os.version];
	if (context.children.sw.os.version === context.children.sw.os.data.latest) {
		osVersions.push('latest');
		osVersions.push(null);
	}

	const variants = [context.children.sw['stack-variant'].slug];
	if (context.children.sw['stack-variant'].slug === 'run') {
		variants.push(null);
	}

	let repo = [NAMESPACE, context.imageName].join('/');
	let tags = generateCombinations([
		stackVersions,
		osVersions,
		variants,
		[yyyymmdd(), null],
	]);

	// loop over all tags and append the repo as a prefix
	let repoTags = tags.map((tag) => {
		return [repo, tag].join(':');
	});

	// for debian projects create aliases without the os suffix
	if (context.children.sw.os.slug === 'debian') {
		repo = [NAMESPACE, context.imageName.replace('-debian', '')].join('/');
		// loop over all tags and append the repo as a prefix
		repoTags = [
			...repoTags,
			...tags.map((tag) => {
				return [repo, tag].join(':');
			}),
		];
	}

	generateBakeFile(context, repoTags);
}

const NAMESPACE = 'docker.io/balenalib';
const DEST_DIR = path.join(__dirname, '../library');
const BLUEPRINT_PATHS = {
	'os-arch': path.join(__dirname, 'blueprints/os-arch.yaml'),
	'os-device': path.join(__dirname, 'blueprints/os-device.yaml'),
	'stack-device': path.join(__dirname, 'blueprints/stack-device.yaml'),
	'stack-arch': path.join(__dirname, 'blueprints/stack-arch.yaml'),
};
const CONTRACTS_PATH = path.join(__dirname, 'contracts/contracts');
const WORKFLOWS_PATH = path.join(__dirname, '../.github/workflows');

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

				if (type === 'os-arch' || type === 'os-device') {
					await generateOsArchLibrary(json);
				}

				if (type === 'stack-device' || type === 'stack-arch') {
					await generateStackLibrary(json);
				}

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
