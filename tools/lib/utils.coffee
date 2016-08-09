fs = require('fs')
path = require('path')


exports.UNSUPPORTED = 'UNSUPPORTED'
exports.SUPPORTED = 'SUPPORTED'
exports.destDir = path.join(path.resolve(__dirname, '../..'), 'resin-base-images')

exports.generateBaseImage = (device, distro, type, variant, suite = '', version = '') ->
	arch = device.$arch[distro.id].alias
	if distro.id is 'debian'
		base = "#{device.id}"
	else
		base = "#{device.id}-#{distro.id}"

	if type is 'device'
		return "resin/#{arch}-#{distro.id}:#{suite}"

	if type is 'buildpack'
		if variant is 'curl'
			return "resin/#{device.id}-#{distro.id}:#{suite}"
		if variant is 'scm'
			return "resin/#{base}-buildpack-deps:#{suite}-curl"
		if variant is 'latest'
			return "resin/#{base}-buildpack-deps:#{suite}-scm"

	# Only language specific types left
	if variant is 'latest'
		return "resin/#{base}-buildpack-deps:latest"
	if variant is 'slim'
		return "resin/#{device.id}-#{distro.id}:latest"
	if variant is 'onbuild'
		return "resin/#{base}-#{type}:#{version}"
	if variant is 'old_suite'
		return "resin/#{base}-buildpack-deps:#{distro.suite[1]}"