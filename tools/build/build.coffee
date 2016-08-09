fs = require('fs')
path = require('path')

_ = require('lodash')
consolidate = require('consolidate')

Metalsmith = require('metalsmith')
dynamic = require('metalsmith-dynamic')
inplace = require('metalsmith-in-place')
HbHelper = require('@resin.io/doxx-handlebars-helper')
{ defaultPartialsSearch } = require('@resin.io/doxx-utils')

plugins = require('./ms-plugins')
utils = require('../lib/utils')

rootDir = path.resolve(__dirname, '..')

# monkey-patch
originalCompile = HbHelper.Handlebars.compile
HbHelper.Handlebars.compile = (program, options = {}) ->
  options.noEscape = true
  return originalCompile(program, options)

HbHelper.registerConsolidate(consolidate, importName: 'include')
require('./hb-helpers')(HbHelper.Handlebars)

metalsmith = Metalsmith(rootDir)
.source('src')
.destination(utils.destDir)
.use(defaultPartialsSearch())
.use(dynamic({
  dictionaries: path.join(rootDir, 'dicts')
  populateFields: [ '$partials_search' ]
}))
.use(plugins.expandProps())
.use(plugins.dropUnsupported())
.use(plugins.copySupportingFiles())
.use(inplace({
  engine: 'handlebars'
  partials: 'partials'
}))
.build (err) ->
  if err
    console.error err, err.stack
    throw err
  else
    console.log('Done')
