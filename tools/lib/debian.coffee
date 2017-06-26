semver = require('semver')
utils = require('./utils')

exports.getDebianStatus = (arch, suite) ->
	if arch is 'aarch64' and suite is 'wheezy'
		return utils.UNSUPPORTED
	return utils.SUPPORTED