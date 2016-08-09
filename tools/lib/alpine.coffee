semver = require('semver')
utils = require('./utils')

exports.getAlpineLabel = (arch, qemu) ->
	return "io.resin.architecture=\"#{arch}\" io.resin.qemu.version=\"#{qemu}\""
