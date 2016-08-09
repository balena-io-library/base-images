utils = require('../lib/utils')
alpineHelper = require('../lib/alpine')

module.exports = registerHelpers = (Handlebars) ->

	# Helpers for alpine
	Handlebars.registerHelper 'getAlpineLabel', ->
		{ $alpine_arch: arch, $alpine_arch: suite, $qemu: qemu } = this
		return alpineHelper.getAlpineLabel(arch.id, qemu.id)