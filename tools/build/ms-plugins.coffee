{ walkFiles } = require('@resin.io/doxx-utils')
HbHelper = require('@resin.io/doxx-handlebars-helper')

path = require('path')
fse = require('fs-extra')
semver = require('semver')

utils = require('../lib/utils')

removeFile = (isUnsupported, file, files) ->
	if isUnsupported is utils.UNSUPPORTED
		delete files[file]

copyFile = (src, dest) ->
	try
		fse.copySync(src, dest)
	catch err
		console.error(err)

copyAlpineFile = (obj, destDir) ->
	copyFile('./supporting_files/alpine.rc.conf', "#{destDir}/rc.conf")
	copyFile('./supporting_files/alpine.resin', "#{destDir}/resin")
	copyFile('./supporting_files/alpine.entry.sh', "#{destDir}/entry.sh")
	if obj.$alpine_arch.id != 'amd64' and obj.$alpine_arch.id != 'i386'
		copyFile('./resin-xbuild', "#{destDir}/resin-xbuild")
		if obj.$alpine_arch.id is 'aarch64'
			copyFile('./qemu-aarch64-static', "#{destDir}/qemu-aarch64-static")
		else
			copyFile('./qemu-arm-static', "#{destDir}/qemu-arm-static")

copyDebianFile = (obj, destDir) ->
	copyFile('./supporting_files/debian.01_buildconfig', "#{destDir}/01_buildconfig")
	copyFile('./supporting_files/debian.01_nodoc', "#{destDir}/01_nodoc")

	# Systemd
	if obj.$debian_suite.id is 'wheezy'
		copyFile('./supporting_files/debian.entry-nosystemd.sh', "#{destDir}/entry.sh")
	else
		copyFile('./supporting_files/debian.entry.sh', "#{destDir}/entry.sh")
		copyFile('./supporting_files/debian.launch.service', "#{destDir}/launch.service")

	# QEMU
	if obj.$debian_arch.id != 'amd64' and obj.$debian_arch.id != 'i386'
		copyFile('./resin-xbuild', "#{destDir}/resin-xbuild")
		if obj.$debian_arch.id is 'aarch64'
			copyFile('./qemu-aarch64-static', "#{destDir}/qemu-aarch64-static")
		else
			copyFile('./qemu-arm-static', "#{destDir}/qemu-arm-static")

copyFedoraFile = (obj, destDir) ->

	copyFile('./supporting_files/debian.entry.sh', "#{destDir}/entry.sh")
	copyFile('./supporting_files/debian.launch.service', "#{destDir}/launch.service")

	# QEMU
	if obj.$fedora_arch.id != 'amd64'
		copyFile('./resin-xbuild', "#{destDir}/resin-xbuild")
		if obj.$fedora_arch.id is 'aarch64'
			copyFile('./qemu-aarch64-static', "#{destDir}/qemu-aarch64-static")
		else
			copyFile('./qemu-arm-static', "#{destDir}/qemu-arm-static")

exports.expandProps = walkFiles (file, files) ->
	obj = files[file]
	propsToExpand = obj.expand_props
	return if not propsToExpand
	for prop in propsToExpand
		obj[prop] = HbHelper.render(obj[prop], obj)

exports.dropUnsupported = walkFiles (file, files) ->
	obj = files[file]
	removeFile(obj.$arch, file, files)
	removeFile(obj.$isUnsupported, file, files)

exports.copySupportingFiles = walkFiles (file, files) ->
	destDir = path.join(utils.destDir, path.dirname(file))
	obj = files[file]

	# Copy supporting files for Alpine
	if obj.$type is 'alpine'
		copyAlpineFile(obj, destDir)

	# Copy supporting files for Debian
	if obj.$type is 'debian'
		copyDebianFile(obj, destDir)

	# Copy supporting files for Fedora
	if obj.$type is 'fedora'
		copyFedoraFile(obj, destDir)