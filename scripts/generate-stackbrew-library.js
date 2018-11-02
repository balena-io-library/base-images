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

'use strict'

const _ = require('lodash')
const fs = require('fs-extra')
const path = require('path')
const contrato = require('@balena/contrato')
const yaml = require('js-yaml')
const { execSync } = require('child_process');

function yyyymmdd () {
    var now = new Date();
    var y = now.getFullYear();
    var m = now.getMonth() + 1;
    var d = now.getDate();
    return '' + y + (m < 10 ? '0' : '') + m + (d < 10 ? '0' : '') + d;
}

function getVersionAliases (version) {
  // version can be a full version x.y.z or x.y or just x.
  const result = [version]
  var versionAlias = version.match('\([0-9]*\.[0-9]*\)')
  if (!result.includes(versionAlias[0])) result.push(versionAlias[0])
  versionAlias = version.match('\([0-9]*\)')
  if (!result.includes(versionAlias[0])) result.push(versionAlias[0])
  return result
}

// Generate combinations that contain one element from each of the given arrays
// Inspired by https://www.geeksforgeeks.org/combinations-from-n-arrays-picking-one-element-from-each-array/
function generateCombinations (arr) {
  const combinations = []
  const result = []

  const n = arr.length
  // keep track index in each of the n arrays
  const indices = new Array(n).fill(0)

  while (true) {
    let tmp = []

    // store current combination
    for (var i = 0; i < n; i++) { 
      tmp.push(arr[i][indices[i]])
    }

    combinations.push(tmp.filter(n => n).join("-"))

    // find the rightmost array that has more element left after the current element
    var next = n - 1
    while (next >= 0 && indices[next] + 1 >= arr[next].length) {
      next--
    }

    // no such array is found so no more combinations left
    if (next < 0) {
      break
    }

    // if next element is found then set the indices for next combination
    indices[next]++
    for(i = next + 1; i < n; i++) {
      indices[i] = 0
    }
  }

  return combinations.filter(n => n)
}


function generateOsArchLibrary (context) {
  const osVersions = [context.children.sw.os.version]
  if (context.children.sw.os.version === context.children.sw.os.data.latest) {
    osVersions.push('latest')
    osVersions.push(null)
  }

  const variants = [context.children.sw["stack-variant"].slug]
  if (context.children.sw["stack-variant"].slug === 'run') {
    variants.push(null)
  }

  const commit = execSync(`git log -1 --format='%H' -- ${path.join(DOCKERFILE_DIR,context.path)}`).toString()

  var tags = generateCombinations([osVersions, variants, [yyyymmdd(), null]])

  const destination = path.join(
    DEST_DIR,
    context.imageName
  )

  const content = {
    tag: tags[0],
    repoDir: `${URL}@${commit.slice(0, -1)} ${path.join(ROOT, context.path)}`,
    alias: tags.join(' ')
  }

  fs.appendFileSync(destination, JSON.stringify(content))
  fs.appendFileSync(destination, `\n`)
}

function generateStackLibrary (context) {
  const stackVersions = getVersionAliases(context.children.sw.stack.version)
  if (context.children.sw.stack.version === context.children.sw.stack.data.latest) {
    stackVersions.push('latest')
    stackVersions.push(null)
  }

  const osVersions = [context.children.sw.os.version]
  if (context.children.sw.os.version === context.children.sw.os.data.latest) {
    osVersions.push('latest')
    osVersions.push(null)
  }

  const variants = [context.children.sw["stack-variant"].slug]
  if (context.children.sw["stack-variant"].slug === 'run') {
    variants.push(null)
  }

  const commit = execSync(`git log -1 --format='%H' -- ${path.join(DOCKERFILE_DIR,context.path)}`).toString()

  var tags = generateCombinations([stackVersions, osVersions, variants, [yyyymmdd(), null]])

  const destination = path.join(
    DEST_DIR,
    context.imageName
  )

  const content = {
    tag: tags[0],
    repoDir: `${URL}@${commit.slice(0, -1)} ${path.join(ROOT, context.path)}`,
    alias: tags.join(' ')
  }

  fs.appendFileSync(destination, JSON.stringify(content))
  fs.appendFileSync(destination, `\n`)
}

const URL = 'git://github.com/balena-io-library/base-images'
const ROOT = 'balena-base-images'
const DEST_DIR = path.join(__dirname, '../library')
const DOCKERFILE_DIR = path.join(__dirname, '../balena-base-images')
const BLUEPRINT_PATHS = {
  'os-arch': path.join(__dirname, 'blueprints/os-arch.yaml'),
  'os-device': path.join(__dirname, 'blueprints/os-device.yaml'),
  'stack-device': path.join(__dirname, 'blueprints/stack-device.yaml'),
  'stack-arch': path.join(__dirname, 'blueprints/stack-arch.yaml')
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

let blueprints = types

if (types.indexOf('all') > -1) {
  // Generate dockerfile for all blueprints
  blueprints = Object.keys(BLUEPRINT_PATHS)
}

for (const type of blueprints) {
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
  fs.ensureDirSync(DEST_DIR)
  for (const context of result) {
    const json = context.toJSON()

    if (type === 'os-arch' || type === 'os-device' ) {
      generateOsArchLibrary(json)
    }

    if (type === 'stack-device' || type === 'stack-arch') {
      generateStackLibrary(json)
    }
  }

  console.log(`Generated ${result.length} results out of ${universe.getChildren().length} contracts`)
  console.log(`Adding generated ${result.length} contracts back to the universe`)
  universe.addChildren(result)
}
