/*
 * Copyright 2017 resin.io
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

'use strict'

const _ = require('lodash')
const fs = require('fs-extra')
const path = require('path')
const contrato = require('@resin.io/contrato')
const yaml = require('js-yaml')

const DEST_DIR = path.join(__dirname, '../resin-base-images')
const BLUEPRINT_PATHS = {
  'os-arch': path.join(__dirname, 'blueprints/os-arch.yaml')
}
const CONTRACTS_PATH = path.join(__dirname, 'contracts/contracts')

// Find and build all contracts from the contracts/ directory
const allContracts = require('require-all')({
  dirname: CONTRACTS_PATH,
  filter: /.json$/,
  recursive: true,
  resolve: (json) => {
    return contrato.Contract.build(json)
  }
})

const contracts = _.reduce(_.values(allContracts), (accumulator, value) => {
  return _.concat(accumulator, _.flattenDeep(_.map(_.values(value), _.values)))
}, [])

// Create universe of contracts
const universe = new contrato.Contract({
  type: 'meta.universe'
})
universe.addChildren(contracts)

// Remove `resinos` OS contract since we don't want it for the base images
const children = universe.findChildren(contrato.Contract.createMatcher({
  type: 'sw.os',
  slug: 'resinos'
}))

children.forEach((child) => {
  universe.removeChild(child)
})

// Load arguments
const types = process.argv.slice(2)
if (types.length === 0) {
  console.error(`Usage: ${process.argv[0]} ${process.argv[1]} <types...>`)
  process.exit(1)
}

for (const type of types) {
  if (!BLUEPRINT_PATHS[type]) {
    console.error(`Blueprint for this base images type: ${type} is missing!`)
    process.exit(1)
  }

  const query = yaml.safeLoad(fs.readFileSync(BLUEPRINT_PATHS[type], 'utf8'))

  // Execute query
  const result = contrato.query(universe, query.selector, query.output)

  // Get templates
  const template = query.output.template[0].data

  // Write output
  for (const context of result) {
    const json = context.toJSON()
    const destination = path.join(
      DEST_DIR,
      json.path,
      query.output.filename
    )

    console.log(`Generating ${json.slug}`)
    fs.outputFileSync(destination, contrato.buildTemplate(template, context, {
      directory: CONTRACTS_PATH
    }))

    if (json.children.sw.blob) {
      // Check and copy local blobs to target directory.
      for (const blob of _.values(json.children.sw.blob)) {
        if (blob.assets.bin.url.indexOf('file://') > -1) {
          try {
            const src = path.join(__dirname, blob.assets.bin.url.replace('file://', ''))
            fs.copySync(src, path.join(path.dirname(destination), blob.assets.bin.main))
          } catch (err) {
            throw new Error('Error when copying ' + blob.assets.bin.name + ' to ' + path.dirname(destination))
          }
        }
      }
    }
  }

  console.log(`Generated ${result.length} results out of ${universe.getChildren().length} contracts`)
  console.log(`Adding generated ${result.length} contracts back to the universe`)
  universe.addChildren(result)
}
