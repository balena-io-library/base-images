utils = require('../lib/utils')
alpineHelper = require('../lib/alpine')
debianHelper = require('../lib/debian')

module.exports = registerHelpers = (Handlebars) ->
	# Helpers for alpine
	Handlebars.registerHelper 'getAlpineLabel', ->
		{ $alpine_arch: arch, $alpine_arch: suite, $qemu: qemu } = this
		return alpineHelper.getAlpineLabel(arch.id, qemu.id)

	# Helpers for debian
	Handlebars.registerHelper 'getDebianStatus', ->
		{ $debian_arch: arch, $debian_suite: suite } = this
		return debianHelper.getDebianStatus(arch.id, suite.id)

	Handlebars.registerHelper 'getDebianLabel', ->
		{ $debian_arch: arch, $qemu: qemu } = this
		return debianHelper.getDebianLabel(arch.id, qemu.id)

	Handlebars.registerHelper 'getTiniChecksum', ->
		{ $debian_arch: arch , $tini: tini} = this
		return debianHelper.getTiniChecksum(arch.id, tini)