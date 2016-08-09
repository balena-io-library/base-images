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