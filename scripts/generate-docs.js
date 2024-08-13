/*
 * Copyright 2024 balena.io
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

"use strict";

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

const DOCS_DIRECTORY = path.join(__dirname, '../docs');

const balena = getSdk({
  apiUrl: 'https://api.balena-cloud.com/',
  dataDirectory: false,
});

const BLUEPRINT_PATHS = {
  'os-arch': path.join(__dirname, 'blueprints/os-arch.yaml'),
  'os-device': path.join(__dirname, 'blueprints/os-device.yaml'),
  'stack-device': path.join(__dirname, 'blueprints/stack-device.yaml'),
  'stack-arch': path.join(__dirname, 'blueprints/stack-arch.yaml'),
};

const CONTRACTS_DIRECTORY = path.join(__dirname, 'contracts/contracts');

// Find and build all contracts from the contracts/ directory
const allContracts = requireAll({
  dirname: CONTRACTS_DIRECTORY,
  filter: /.json$/,
  recursive: true,
  resolve: (json) => {
    // We only want to generate dockerfiles for the canonical contracts
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

/**
 * Generates a Markdown table from the provided data.
 * @param {Array<Array<string>>} data - The data to generate the table from.
 * @returns {string} The generated Markdown table.
 */
function generateMarkdownTable(data) {
  let table = '';

  // Add header row
  table += '| ' + data[0].join(' | ') + ' |\n';

  // Add separator row
  table += '|' + data[0].map(cell => '-'.repeat(cell.length)).join('|') + '|\n';

  // Add data rows
  for (let i = 1; i < data.length; i++) {
    table += '| ' + data[i].join(' | ') + ' |\n';
  }

  return table;
}

void (async () => {
  console.log('Generating base images docs table');
  await fs.rm(DOCS_DIRECTORY, { recursive: true, force: true });
  await fs.ensureDir(DOCS_DIRECTORY);

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

  let baseImageContracts = [];

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

      await concurrentForEach(result, 5, async (context) => {
        let baseImageContract = {};
        const json = context.toJSON();

        if (json["children"]["hw"] !== undefined) {
          baseImageContract = {
            imageName: json.imageName,
            slug: json["children"]["hw"]["device-type"]["slug"],
            deviceName: json["children"]["hw"]["device-type"]["name"]
          };
        } else {
          baseImageContract = {
            imageName: json.imageName,
            slug: json["requires"][0].arch,
            deviceName: json["requires"][0].arch
          };
        }

        baseImageContracts.push(baseImageContract);
      });
    }),
  );

  /**
   * Group base images by device name, with unique image names.
   * Example:
   * {
   *   "Advantech ECU1370": [
   *     {
   *       "imageName": "advantech-ecu1370-alpine",
   *       "slug": "advantech-ecu1370",
   *       "name": "Advantech ECU1370"
   *     },
   *     {
   *       "imageName": "advantech-ecu1370-debian",
   *       "slug": "advantech-ecu1370",
   *       "name": "Advantech ECU1370"
   *     },
   *   ]
   * }
   */
  baseImageContracts = _.groupBy(
    _.uniqBy(baseImageContracts, "imageName"),
    "deviceName"
  );

  // Generating Markdown from baseImageContracts
  let baseImagesTable = [];

  for (const contractKey of Object.keys(baseImageContracts)) {
    await fs.appendFile(`${DOCS_DIRECTORY}/base-images-ref.md`, `## ${contractKey}\n`);
    await fs.appendFile(`${DOCS_DIRECTORY}/base-images-ref.md`, `\n`);

    baseImagesTable.push(["Image", "Links"]);

    for (let baseImageContract of baseImageContracts[contractKey]) {
      baseImagesTable.push([
        baseImageContract.imageName,
        `[DockerHub](https://hub.docker.com/r/balenalib/${baseImageContract.imageName}) [GitHub](https://github.com/balena-io-library/base-images/tree/master/balena-base-images/device-base/${baseImageContract.slug})`
      ]);
    }

    await fs.appendFile(`${DOCS_DIRECTORY}/base-images-ref.md`, generateMarkdownTable(baseImagesTable) + '\n');
  }
})();