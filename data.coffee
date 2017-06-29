_ = require 'lodash'

# TODO
# - add entry/exit dates
# - add blobs
# - fix FIXME comments
# - make stack versions specific (i.e node 4 -> node 4.5.1)
# - model distro libc and connect blobs to that instead of distro_version

data = {
	arch: [
		{ slug: "armel", name: "arm v5", can_run: ["armel"] },
		{ slug: "rpi", name: "ARM v6", can_run: ["armel", "rpi"] },
		{ slug: "armv7hf", name: "ARM v7", can_run: ["armel", "rpi", "armv7hf"] },
		{ slug: "aarch64", name: "ARM v8", can_run: ["armel", "rpi", "armv7hf", "aarch64"] },
		{ slug: "i386", name: "Intel 32-bit (x86)", can_run: ["i386"] },
		{ slug: "amd64", name: "Intel 64-bit (x86-64)", can_run: [ "i386", "amd64" ] }
	],
	device: [
		{ slug: "am571x-evm", name: "am571x-evm", arch_id: "armv7hf" },
		{ slug: "apalis-imx6q", name: "Toradex Apalis", arch_id: "armv7hf" },
		{ slug: "artik10", name: "Samsung Artik 10", arch_id: "armv7hf" },
		{ slug: "artik5", name: "Samsung Artik 5", arch_id: "armv7hf" },
		{ slug: "artik710", name: "Samsung Artik 710", arch_id: "armv7hf" },
		{ slug: "beaglebone-black", name: "Beaglebone Black", arch_id: "armv7hf" },
		{ slug: "beaglebone-green", name: "Beaglebone Green", arch_id: "armv7hf" },
		{ slug: "beaglebone-green-wifi", name: "Beaglebone Green WiFi", arch_id: "armv7hf" },
		{ slug: "ccon-01", name: "CCON01", arch_id: "armv7hf" },
		{ slug: "colibri-imx6dl", name: "Toradex Colibri", arch_id: "armv7hf" },
		{ slug: "cybertan-ze250", name: "Cybertan ze250", arch_id: "i386" },
		{ slug: "hummingboard", name: "Hummingboard", arch_id: "armv7hf" },
		{ slug: "imx6ul-var-dart", name: "Dart", arch_id: "armv7hf" },
		{ slug: "intel-edison", name: "Intel Edison", arch_id: "i386" },
		{ slug: "intel-nuc", name: "Intel NUC", arch_id: "amd64" },
		{ slug: "kitra710", name: "Kitra 710", arch_id: "armv7hf" },
		{ slug: "nitrogen6x", name: "Nitrogen 6x", arch_id: "armv7hf" },
		{ slug: "odroid-c1", name: "ODroid C1", arch_id: "armv7hf" },
		{ slug: "odroid-xu4", name: "ODroid XU4", arch_id: "armv7hf" },
		{ slug: "parallella", name: "Parallella", arch_id: "armv7hf" },
		{ slug: "qemux86", name: "QEMU x86", arch_id: "i386" },
		{ slug: "qemux86-64", name: "QEMU x86-64", arch_id: "amd64" },
		{ slug: "raspberry-pi", name: "Raspberry Pi (1, Zero, Zero W)", arch_id: "rpi" },
		{ slug: "raspberry-pi2", name: "Raspberry Pi 2", arch_id: "armv7hf" },
		{ slug: "raspberrypi3", name: "Raspberry Pi 3", arch_id: "armv7hf" },
		{ slug: "ts4900", name: "Technologic TS-4900", arch_id: "armv7hf" },
		{ slug: "ts7700", name: "Technologic TS-7700", arch_id: "armel" },
		{ slug: "up-board", name: "UP Board", arch_id: "amd64" },
		{ slug: "via-vab820-quad", name: "VIA vab820", arch_id: "armv7hf" },
		{ slug: "zc702-zynq7", name: "Zynq zc702", arch_id: "armv7hf" }
	],
	distro_supports_device: [
		{ distro_id: "raspbian", device_id: "raspberry-pi" },
		{ distro_id: "raspbian", device_id: "raspberry-pi2" },
		{ distro_id: "raspbian", device_id: "raspberrypi3" },
	],
	distro: [
		{ slug: "debian", name: "Debian" },
		{ slug: "raspbian", name: "Raspbian" },
		{ slug: "alpine", name: "Alpine Linux" },
		{ slug: "fedora", name: "Fedora" }
	],
	distro_version: [
		{ id: 1, distro_id: "debian", slug: "wheezy" },
		{ id: 2, distro_id: "debian", slug: "jessie" },
		{ id: 3, distro_id: "debian", slug: "stretch" },
		{ id: 4, distro_id: "raspbian", slug: "wheezy" },
		{ id: 5, distro_id: "raspbian", slug: "jessie" },
		{ id: 6, distro_id: "raspbian", slug: "stretch" },
		{ id: 7, distro_id: "alpine", slug: "3.5" },
		{ id: 8, distro_id: "alpine", slug: "3.6" },
		{ id: 9, distro_id: "alpine", slug: "edge" },
		{ id: 10, distro_id: "fedora", slug: "24" },
		{ id: 11, distro_id: "fedora", slug: "25" }
	],
	distro_version_supports_arch: [
		{ distro_version_id: 1, arch_id: "armel" },
		{ distro_version_id: 1, arch_id: "armv7hf" },
		{ distro_version_id: 1, arch_id: "aarch64" },
		{ distro_version_id: 1, arch_id: "i386" },
		{ distro_version_id: 1, arch_id: "amd64" },
		{ distro_version_id: 2, arch_id: "armel" },
		{ distro_version_id: 2, arch_id: "armv7hf" },
		{ distro_version_id: 2, arch_id: "aarch64" },
		{ distro_version_id: 2, arch_id: "i386" },
		{ distro_version_id: 2, arch_id: "amd64" },
		{ distro_version_id: 3, arch_id: "armel" },
		{ distro_version_id: 3, arch_id: "armv7hf" },
		{ distro_version_id: 3, arch_id: "aarch64" },
		{ distro_version_id: 3, arch_id: "i386" },
		{ distro_version_id: 3, arch_id: "amd64" },

		{ distro_version_id: 4, arch_id: "rpi" },
		{ distro_version_id: 5, arch_id: "rpi" },
		{ distro_version_id: 6, arch_id: "rpi" },

		{ distro_version_id: 7, arch_id: "armv7hf" },
		{ distro_version_id: 7, arch_id: "aarch64" },
		{ distro_version_id: 7, arch_id: "i386" },
		{ distro_version_id: 7, arch_id: "amd64" },
		{ distro_version_id: 8, arch_id: "armv7hf" },
		{ distro_version_id: 8, arch_id: "aarch64" },
		{ distro_version_id: 8, arch_id: "i386" },
		{ distro_version_id: 8, arch_id: "amd64" },
		{ distro_version_id: 9, arch_id: "armv7hf" },
		{ distro_version_id: 9, arch_id: "aarch64" },
		{ distro_version_id: 9, arch_id: "i386" },
		{ distro_version_id: 9, arch_id: "amd64" },

		{ distro_version_id: 10, arch_id: "armv7hf" },
		{ distro_version_id: 10, arch_id: "aarch64" },
		{ distro_version_id: 10, arch_id: "i386" },
		{ distro_version_id: 10, arch_id: "amd64" },
		{ distro_version_id: 11, arch_id: "armv7hf" },
		{ distro_version_id: 11, arch_id: "aarch64" },
		{ distro_version_id: 11, arch_id: "i386" },
		{ distro_version_id: 11, arch_id: "amd64" },
	],
	stack: [
		{ slug: "node", name: "node.js", default_distro_version_id: 3 },
		{ slug: "java", name: "Java", default_distro_version_id: 3 },
		{ slug: "python", name: "Python", default_distro_version_id: 3 },
		{ slug: "go", name: "Go", default_distro_version_id: 3 }
	],
	stack_version: [
		{ id: 1, stack_id: "node", version: "0.10", },
		{ id: 2, stack_id: "node", version: "0.12", },
		{ id: 3, stack_id: "node", version: "4", },
		{ id: 4, stack_id: "node", version: "5", },
		{ id: 5, stack_id: "node", version: "6", },
		{ id: 6, stack_id: "node", version: "7", },
		{ id: 7, stack_id: "node", version: "8", },
		{ id: 8, stack_id: "java", version: "7", },
		{ id: 9, stack_id: "java", version: "8.0.0", },
		{ id: 10, stack_id: "python", version: "2.7", },
		{ id: 11, stack_id: "python", version: "3.3", },
		{ id: 12, stack_id: "python", version: "3.4", },
		{ id: 13, stack_id: "python", version: "3.5", },
		{ id: 14, stack_id: "python", version: "3.6", },
		{ id: 15, stack_id: "go", version: "1.4", },
		{ id: 16, stack_id: "go", version: "1.5", },
		{ id: 17, stack_id: "go", version: "1.6", },
		{ id: 18, stack_id: "go", version: "1.7", },
		{ id: 19, stack_id: "go", version: "1.8", },
	],
	stack_version_supports_arch: [
		{ stack_version_id: 1, arch_id: "armel" },
		{ stack_version_id: 1, arch_id: "rpi" },
		{ stack_version_id: 1, arch_id: "armv7hf" },
		{ stack_version_id: 1, arch_id: "aarch64" },
		{ stack_version_id: 1, arch_id: "i386" },
		{ stack_version_id: 1, arch_id: "amd64" },

		{ stack_version_id: 2, arch_id: "armel" },
		{ stack_version_id: 2, arch_id: "rpi" },
		{ stack_version_id: 2, arch_id: "armv7hf" },
		{ stack_version_id: 2, arch_id: "aarch64" },
		{ stack_version_id: 2, arch_id: "i386" },
		{ stack_version_id: 2, arch_id: "amd64" },

		{ stack_version_id: 3, arch_id: "armel" },
		{ stack_version_id: 3, arch_id: "rpi" },
		{ stack_version_id: 3, arch_id: "armv7hf" },
		{ stack_version_id: 3, arch_id: "aarch64" },
		{ stack_version_id: 3, arch_id: "i386" },
		{ stack_version_id: 3, arch_id: "amd64" },

		{ stack_version_id: 4, arch_id: "armel" },
		{ stack_version_id: 4, arch_id: "rpi" },
		{ stack_version_id: 4, arch_id: "armv7hf" },
		{ stack_version_id: 4, arch_id: "aarch64" },
		{ stack_version_id: 4, arch_id: "i386" },
		{ stack_version_id: 4, arch_id: "amd64" },

		{ stack_version_id: 5, arch_id: "armel" },
		{ stack_version_id: 5, arch_id: "rpi" },
		{ stack_version_id: 5, arch_id: "armv7hf" },
		{ stack_version_id: 5, arch_id: "aarch64" },
		{ stack_version_id: 5, arch_id: "i386" },
		{ stack_version_id: 5, arch_id: "amd64" },

		{ stack_version_id: 6, arch_id: "armel" },
		{ stack_version_id: 6, arch_id: "rpi" },
		{ stack_version_id: 6, arch_id: "armv7hf" },
		{ stack_version_id: 6, arch_id: "aarch64" },
		{ stack_version_id: 6, arch_id: "i386" },
		{ stack_version_id: 6, arch_id: "amd64" },

		{ stack_version_id: 7, arch_id: "armel" },
		{ stack_version_id: 7, arch_id: "rpi" },
		{ stack_version_id: 7, arch_id: "armv7hf" },
		{ stack_version_id: 7, arch_id: "aarch64" },
		{ stack_version_id: 7, arch_id: "i386" },
		{ stack_version_id: 7, arch_id: "amd64" },

		# FIXME: missing Java archs
		{ stack_version_id: 8, arch_id: "amd64" },
		{ stack_version_id: 9, arch_id: "amd64" },

		# FIXME: missing python archs
		{ stack_version_id: 10, arch_id: "amd64" },
		{ stack_version_id: 11, arch_id: "amd64" },
		{ stack_version_id: 12, arch_id: "amd64" },
		{ stack_version_id: 13, arch_id: "amd64" },
		{ stack_version_id: 14, arch_id: "amd64" },

		{ stack_version_id: 15, arch_id: "armv7hf" },
		{ stack_version_id: 15, arch_id: "aarch64" },
		{ stack_version_id: 15, arch_id: "i386" },
		{ stack_version_id: 15, arch_id: "amd64" },
		{ stack_version_id: 16, arch_id: "armv7hf" },
		{ stack_version_id: 16, arch_id: "aarch64" },
		{ stack_version_id: 16, arch_id: "i386" },
		{ stack_version_id: 16, arch_id: "amd64" },
		{ stack_version_id: 17, arch_id: "armv7hf" },
		{ stack_version_id: 17, arch_id: "aarch64" },
		{ stack_version_id: 17, arch_id: "i386" },
		{ stack_version_id: 17, arch_id: "amd64" },
		{ stack_version_id: 18, arch_id: "armv7hf" },
		{ stack_version_id: 18, arch_id: "aarch64" },
		{ stack_version_id: 18, arch_id: "i386" },
		{ stack_version_id: 18, arch_id: "amd64" },
		{ stack_version_id: 19, arch_id: "armv7hf" },
		{ stack_version_id: 19, arch_id: "aarch64" },
		{ stack_version_id: 19, arch_id: "i386" },
		{ stack_version_id: 19, arch_id: "amd64" },
	],
	variant: [
		{ slug: "slim", },
		{ slug: "onbuild", },
		{ slug: "jdk", },
		{ slug: "jre", }
	],

	variant_is_compatible_with_distro_and_stack: [
		{ variant_id: "slim", distro_id: "fedora", stack_id: "go" },
		{ variant_id: "slim", distro_id: "debian", stack_id: "go" },
		{ variant_id: "slim", distro_id: "raspbian", stack_id: "go" },
		{ variant_id: "slim", distro_id: "alpine", stack_id: "go" },
		{ variant_id: "slim", distro_id: "fedora", stack_id: "node" },
		{ variant_id: "slim", distro_id: "debian", stack_id: "node" },
		{ variant_id: "slim", distro_id: "raspbian", stack_id: "node" },
		{ variant_id: "slim", distro_id: "alpine", stack_id: "node" },
		{ variant_id: "slim", distro_id: "fedora", stack_id: "python" },
		{ variant_id: "slim", distro_id: "debian", stack_id: "python" },
		{ variant_id: "slim", distro_id: "raspbian", stack_id: "python" },
		{ variant_id: "slim", distro_id: "alpine", stack_id: "python" },
		{ variant_id: "onbuild", distro_id: "fedora", stack_id: "go" },
		{ variant_id: "onbuild", distro_id: "debian", stack_id: "go" },
		{ variant_id: "onbuild", distro_id: "raspbian", stack_id: "go" },
		{ variant_id: "onbuild", distro_id: "alpine", stack_id: "go" },
		{ variant_id: "onbuild", distro_id: "fedora", stack_id: "node" },
		{ variant_id: "onbuild", distro_id: "debian", stack_id: "node" },
		{ variant_id: "onbuild", distro_id: "raspbian", stack_id: "node" },
		{ variant_id: "onbuild", distro_id: "alpine", stack_id: "node" },
		{ variant_id: "onbuild", distro_id: "fedora", stack_id: "python" },
		{ variant_id: "onbuild", distro_id: "debian", stack_id: "python" },
		{ variant_id: "onbuild", distro_id: "raspbian", stack_id: "python" },
		{ variant_id: "onbuild", distro_id: "alpine", stack_id: "python" },
		{ variant_id: "jdk", distro_id: "fedora", stack_id: "java" },
		{ variant_id: "jdk", distro_id: "debian", stack_id: "java" },
		{ variant_id: "jdk", distro_id: "raspbian", stack_id: "java" },
		{ variant_id: "jdk", distro_id: "alpine", stack_id: "java" },
		{ variant_id: "jre", distro_id: "fedora", stack_id: "java" },
		{ variant_id: "jre", distro_id: "debian", stack_id: "java" },
		{ variant_id: "jre", distro_id: "raspbian", stack_id: "java" },
		{ variant_id: "jre", distro_id: "alpine", stack_id: "java" },
	],
	blob: [
		{ id: 1, stack_version_id: 7, name: "node", version: "8.0.0" }
	],
	blob_runs_on_distro_version_supports_arch: [
		{ blob_id: 1, distro_version_supports_arch_id: 1, url: "", checksum: "fd3633733b4fc82b97a1a87c4fb67b1b7a3654fb9f65e2b96dbbba29f97c629f" }
	]
}

for stack in data.stack_version
	for distro in data.distro_version
		for device in data.device
			for variant in data.variant
				hasVariant = data.variant_is_compatible_with_distro_and_stack.some (r) ->
					r.variant_id is variant.slug and r.distro_id is distro.distro_id and r.stack_id is stack.stack_id

				deviceArchs = _.find(data.arch, slug: device.arch_id).can_run

				distroVersionArchs = _.filter(data.distro_version_supports_arch, distro_version_id: distro.id).map(({arch_id}) -> arch_id)
				distro_arch = _.intersection(deviceArchs, distroVersionArchs).pop()

				stackVersionArchs = _.filter(data.stack_version_supports_arch, stack_version_id: stack.id).map(({arch_id}) -> arch_id)
				stack_arch = _.intersection(deviceArchs, stackVersionArchs).pop()

				if _.filter(data.distro_supports_device, distro_id: distro.distro_id).length isnt 0 and not _.find(data.distro_supports_device, { distro_id: distro.distro_id, device_id: device.slug })
					continue

				if not (hasVariant and distro_arch and stack_arch)
					continue
				
				obj = {device, stack, distro, stack_arch, distro_arch, variant }
				console.log(JSON.stringify(obj))