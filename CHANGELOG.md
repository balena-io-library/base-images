# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).


## 2019-29-05

### Changed

`Contracts v1.1.49`
- openjdk: Fix missing javac in few Fedora OpenJDK images.
- node: Add v12.3.1 and v10.16.0.
- devices: Add support for MS Surface 6.


## 2019-22-05

### Changed

`Contracts v1.1.46`
- node: Add glibc i386 binary for v10.
- node: Add v12.2.0.
- device: Add contract for Orange Pi Lite.
- device: Add contract for Nvidia blackboard TX2.
- dotnet: Version update for dotnet sdk, runtime and aspnet.
- aspnet: Install .NET Runtime before aspnet for v3.0


## 2019-11-05

### Changed

`Contracts v1.1.42`
- python: Fix wrong partials when generates Dockerfile for Python base images.
- device: Add support for Beaglebone Fastenal.
- device: Add support for Nvidia D3 TX2.


## 2019-06-05

### Changed

`Contracts v1.1.39`
- node: Add support for v12.1.0, v8.16.0 and v11.15.0.
- python: Add support for v2.7.16 v3.7.3 v3.5.7 and v3.4.10.
- openJDK: Update latest openJDK version.
- node: v6.x EOL.


## 2019-03-05

### Changed

`Contracts v1.1.36`
- qemu: Update QEMU to v4.0.0+balena.


## 2019-23-04

### Changed

`Contracts v1.1.34`
- dockerhub: Add partials for dotnet dockerhub description.


## 2019-18-04

### Changed

`Contracts v1.1.31`
- dockerhub: Add scripts and blueprints to generate dockerhub description.
- newDevice: Add contract for Nvidia Jetson Nano and BepMarine DL-PM6X.

## 2019-01-04

### Changed

`Contracts v1.1.29`
- node: Add node v11.12.0.
- go: Add v1.12.1 and v1.11.6.
- alpine: Change Alpine Linux v3.9 and edge from arm32v6 to arm32v7.
- alpine: Add support for armv7hf stack base images.


## 2019-25-03

### Changed

`Contracts v1.1.26`
- node: Add v11.10.1 v10.15.3 v8.15.1 and v6.17.0.
- go: Add v1.12.
- Add contract for Aetina N510 TX2.
- Add contract for Nitrogen 6X Quad 2GB.
- Add contract for NPE X500 M3.


## 2019-01-03

### Changed

`Contracts v1.1.23`
- device: Add contract for Raspberry Pi 3 64bits.
- golang: Add v1.11.5 and v1.10.8 to Golang contract.
- node: Add v11.10.0 to Node contract.
- device: Add support for Orange Pi One.
- openjdk: Update Fedora openjdk images.
- fedora: Add suppor for Fedora 29 and 30.
- alpineLinux: Install libssl1.1 on latest Alpine Linux.
- newDevice: Add contract for Orange Pi Zero.


## 2019-16-02

### Changed

`Contracts v1.1.20`
- Add support for Alpine Linux 3.9.
- Update pip to v19.01 and setuptools to v40.6.3.
- Add ui component to rpi family base images sources list.
- Add node v11.9.0 and v10.15.1.
- Add procps package to default package list for Debian base images.


## 2019-15-02

### Changed

- entryscript: Use clean tmp mount when mounting /dev as devtmpfs.


## 2019-27-01

### Changed

`Contracts v1.1.17`
- Add node v11.6.0 v10.15.0 v8.15.0 and v6.16.0.
- Update checksum for Python v2.7.15.


## 2019-23-01

### Changed

`Contracts v1.1.16`
- Add support for new devices: cl-som-imx8, imx8m-var-dart.
- Add new Python versions: v3.7.2 and v3.6.8.
- Fix mraa build build dependencies and update to v2.0.0.
- Add ONBUILD warning message for deprecated resin base images.


## 2018-09-12

### Changed

- new-device: Add new device revpi-core-3.
- new-device: Add new device stem-x86-32.


## 2018-08-31

### Changed

- node: Add node v10.9.0 v8.11.4 and v6.14.4.
- node: Update yarn to v1.6.0.


## 2018-08-20

### Changed

- node: Add node v10.7.0.
- beagle-bone: Fix broken systemd on Debian Jessie images.
- qemu: Update qemu to v3.0.0+resin


## 2018-08-07

### Changed

- Fix missing language stack images.


## 2018-07-24

### Changed

- Add Python v3.6.6.
- Add support for ubuntu base images (except OpenJDK).


## 2018-07-19

### Changed

- new device: add support for CTI Spacely TX2.
- Add support for new device: CTI Orbitty TX2.
- Add support for Alpine Linux 3.8.


## 2018-07-09

### Changed

- Add blueprint for device-specific base images.


## 2018-06-28

### Changed

- Add Go v1.9.7 and v1.10.3.
- Add Python v2.7.15.
- Add node 6.14.3 8.11.3 9.11.2 and 10.4.1.


## 2018-06-22

### Changed

- Add support for ubuntu base images (at the os-architecture layer).


## 2018-06-04

### Changed

- Use contracts to generate the os-architecture based base images.


## 2018-06-01

### Changed

- Add support for new device: artik533s and artik530.


## 2018-05-28

### Changed

- Add Go v1.10.2 and v1.9.6.
- Add node v10.1.0 v8.11.2 and v6.14.2.
- Fix obsolete debian packages in Debian and Buildpack-deps base images.


## 2018-05-22

### Changed

- Fix duplicate tag error for OpenJDK base images.
- Update ca-certificates-java version for Debian Stretch base images.


## 2018-05-19

### Changed

- Add support for new device: Balena Fin (CM3).


## 2018-05-16

### Changed

- Add support for new board: orangepi-plus2.


## 2018-05-02

### Changed

- Add Python v3.6.5.
- Update pip to v10.0.1.
- Set PYTHONIOENCODING for Python 2.
- Update setuptools to v39.1.0.
- Add node v9.11.1 v8.11.1 v6.14.1 v4.9.1 and v10.0.0.
- Integrate yarn (v1.5.1) into node base images.


## 2018-03-29

### Changed

- Add Go v1.10.
- Add node v9.9.0 and v8.10.0.
- Add support for Fedora 26 language stack base images (Drop support for Fedora 24 ones).
- Add support for Debian Stretch language stack base images (Drop support for Debian Wheezy ones).
- Redirect all outputs from privilege check to /dev/null (not just stdout).
- Add support for new board: BananPi-M1+.


## 2018-03-23

### Changed

- Change the base images for kitra710 and artik710 to aarch64.
- Add support for two generic device types: aarch64 and generic-armv7ahf.


## 2018-03-22

### Changed

- Update entry script, inspect running container to check if it is privileged container or not. Some functions only run on privileged container.


## 2018-03-18

### Changed

- Integrate mraa/upm into Up-board base images.
- Add node v6.13.1.
- Upgrade mraa to v1.9.0 and upm to v1.6.0.


## 2018-03-04

### Changed

- Add UDEV env var to enable/disable udev for base images.
- Add node v6.13.0.
- Add Go v1.8.7 and v1.9.4.


## 2018-02-22

### Changed

- Add Python v3.6.4 v3.5.5 and v3.4.8.
- Add node v9.5.0.


## 2018-02-09

### Changed

- Apply the LOCK prefix fix for Cybertan base images.


## 2018-02-06

### Changed

- Add node v9.4.0 v8.9.4 and v6.12.3.


## 2018-02-02

### Changed

- Add support for new board: jetson-tx1.


## 2018-01-24

### Changed

- Add VersionBot changes to repository (Autogenerate changelog only).
- Add support for Alpine Linux 3.7 and edge (development branch).


## 2018-01-09

### Changed

- Add node v9.2.1 v8.9.3 v6.12.2 and v4.8.7.


## 2017-12-15

### Changed

- Remove --force-yes apt option in debian base images.


## 2017-12-07

### Changed

- Add node v9.2.0 v8.9.1 v6.12.0 v4.8.6.
- Update sources.list for RPI base images.


## 2017-11-30

### Changed

- Add Golang v1.8.5 and v1.9.2.


## 2017-11-28

### Changed

- Update systemd service restart configuration to restart on-failure only.


## 2017-11-21

### Changed

- Fix library generating script to make sure there will be no duplicate tag.


## 2017-11-17

### Added

- Add support for Fedora 26.
- Add support for new Debian suite: Buster.

### Changed

- Fix issue of broken systemd (/dev/console) in docker container.
- Add node v8.9.0 v9.0.0.
- Add Golang v1.9.1.


## 2017-11-08

### Changed

- Add node v4.8.5, v6.11.5 and v8.8.1.
- Update UPM to v1.5.0 and disable warnings-as-error when building mraa and upm.


## 2017-10-29

### Changed

- Add node v4.8.5, v6.11.5 and v8.8.1.
- Update UPM to v1.5.0 and disable warnings-as-error when building mraa and upm.


## 2017-10-25

### Changed

- libmraa: Update to version 1.8.0.


## 2017-10-25

### Changed

- Integrate the LOCK prefix fix for Iot2000 base images.


## 2017-10-20

### Added
- Add support for new device: Siemens IOT2000.

### Changed

- Change device name of Siemens IOT2000 to lowercase since we can not use uppercase name for docker image name.


## 2017-10-03

### Changed

- Ensure systemd uses /run/dbus/system_bus_socket for dbus.


## 2017-09-29

### Changed

- Add node v8.5.0.
- Add Python v3.5.4 and v3.4.7.
- Remove unnecessary runtime deps for python dbus.


## 2017-09-11

### Added

- Add base images for Go1.9.


## 2017-09-07

### Added

- Add aarch64 base images (aarch64 images set and change jetson-tx2 images from armv7hf to aarch64).


## 2017-08-28

### Changed

- Due to issues between recent systemd and docker, downgrade systemd on Debian Stretch to v230-7(jessie-backports).
- Apply new Python binaries with lzma module installed.
- Add node base images v8.3.0.
- Add support for zulu variant openjdk base images.
- Add base images for all supported architectures.


## 2017-08-22

### Changed

- Remove ccon base images.


## 2017-08-12

### Changed

- Set the latest tag for buildpack-deps base images for Alpine Linux and Fedora to 3.6 and 25 respectively.


## 2017-08-07

### Changed

- Fix issue when environment variable value contains dollar signs will be interpreted before being passed to the application on Alpine Linux.
- Add Python v3.5.3 and v3.6.2.
- Only generate node v0.10.x armel base images.


## 2017-07-23

### Changed

- Fix issue with checksum line format on Debian Wheezy base images.
- Drop support for edge tag on Alpine Linux base images.


## 2017-07-19

### Changed

- Add node v4.8.4 v6.11.1 v7.10.1 and v8.1.4.
- Drop support for edge tag on Alpine Linux base images.


## 2017-07-11

### Changed

- Fix issue with broken udev on Debian stretch base images.


## 2017-07-07

### Changed

- Add support for new boards: Kitra520 and Nvidia Jetson Tx2.
- Fix broken tini on amd64 debian base imaghes.
- apt-get: replace deprecated "force-yes" option with equivalent settings.


## 2017-06-20

### Changed

- Moving the bare minimum base images to official Docker repositories.
	- Add Apline Linux 3.6.
	- Drop support for Alpine Linux 3.2, 3.3, 3.4.
	- Add Fedora 25.
- Integrating Tini as the new default init for all base images.


## 2017-06-12

### Changed

- Add Node v8.0.0.
- Add Python v2.7.13.
- Update QEMU to v2.9.0+resin1. Our base images will be runnable on any x86 machine without any modifications.
- Create empty man directory to fix missing manpage directory issue on Debian base images.


## 2017-05-24

### Changed

- Add Node v7.10.0, v6.10.3 and v4.8.3.
- Update UPM to v1.3.0.
- Update mraa to v1.7.0.
- Fix issue with env var with spaces by adding quotes to the env var value in docker.env file.


## 2017-05-10

### Changed

- Redirect fg stderr to /dev/null to make sure it will not leak to user logs.
- Fix issue with failing to download gpg since dirmngr is missing in Debian Stretch.


## 2017-05-07

### Changed

- Add Node v4.9.0.


## 2017-04-27

### Changed

- Change Raspberry Pi 3 machine name to raspberrypi3.
- Replace module-init-tools with kmod since it is deprecated.

### Added

- Add support for next Debian version: Stretch.


## 2017-04-21

### Changed

- Change the base image for all Debian images to slim variant.


## 2017-04-14

### Changed

- The following base images are now marked as deprecated:
```
raspberrypi-debian raspberrypi-buildpack-deps raspberrypi-golang raspberrypi-node raspberrypi-python raspberrypi-openjdk \
raspberrypi-alpine raspberrypi-alpine-buildpack-deps raspberrypi-alpine-golang raspberrypi-alpine-node raspberrypi-alpine-python raspberrypi-alpine-openjdk \
raspberrypi2-debian raspberrypi2-buildpack-deps raspberrypi2-golang raspberrypi2-node raspberrypi2-python raspberrypi2-openjdk \
raspberrypi2-alpine raspberrypi2-alpine-buildpack-deps raspberrypi2-alpine-golang raspberrypi2-alpine-node raspberrypi2-alpine-python raspberrypi2-alpine-openjdk \
raspberrypi2-fedora raspberrypi2-fedora-buildpack-deps raspberrypi2-fedora-golang raspberrypi2-fedora-node raspberrypi2-fedora-python raspberrypi2-fedora-openjdk \
raspberrypi3-debian raspberrypi3-buildpack-deps raspberrypi3-golang raspberrypi3-node raspberrypi3-python raspberrypi3-openjdk \
raspberrypi3-alpine raspberrypi3-alpine-buildpack-deps raspberrypi3-alpine-golang raspberrypi3-alpine-node raspberrypi3-alpine-python raspberrypi3-alpine-openjdk \
raspberrypi3-fedora raspberrypi3-fedora-buildpack-deps raspberrypi3-fedora-golang raspberrypi3-fedora-node raspberrypi3-fedora-python raspberrypi3-fedora-openjdk \
beaglebone-debian beaglebone-buildpack-deps beaglebone-golang beaglebone-node beaglebone-python beaglebone-openjdk \
beaglebone-alpine beaglebone-alpine-buildpack-deps beaglebone-alpine-golang beaglebone-alpine-node beaglebone-alpine-python beaglebone-alpine-openjdk \
beaglebone-fedora beaglebone-fedora-buildpack-deps beaglebone-fedora-golang beaglebone-fedora-node beaglebone-fedora-python beaglebone-fedora-openjdk \
edison-debian edison-buildpack-deps edison-golang edison-node edison-python edison-openjdk \
edison-alpine edison-alpine-buildpack-deps edison-alpine-golang edison-alpine-node edison-alpine-python edison-alpine-openjdk \
nuc-debian nuc-buildpack-deps nuc-golang nuc-node nuc-python nuc-openjdk \
nuc-alpine nuc-alpine-buildpack-deps nuc-alpine-golang nuc-alpine-node nuc-alpine-python nuc-alpine-openjdk \
nuc-fedora nuc-fedora-buildpack-deps nuc-fedora-golang nuc-fedora-node nuc-fedora-python nuc-fedora-openjdk \
upboard-debian upboard-buildpack-deps upboard-golang upboard-node upboard-python upboard-openjdk \
upboard-alpine upboard-alpine-buildpack-deps upboard-alpine-golang upboard-alpine-node upboard-alpine-python upboard-alpine-openjdk \
upboard-fedora upboard-fedora-buildpack-deps upboard-fedora-golang upboard-fedora-node upboard-fedora-python upboard-fedora-openjdk \
am57xx-evm-debian am57xx-evm-buildpack-deps am57xx-evm-golang am57xx-evm-node am57xx-evm-python am57xx-evm-openjdk \
am57xx-evm-alpine am57xx-evm-alpine-buildpack-deps am57xx-evm-alpine-golang am57xx-evm-alpine-node am57xx-evm-alpine-python am57xx-evm-alpine-openjdk \
am57xx-evm-fedora am57xx-evm-fedora-buildpack-deps am57xx-evm-fedora-golang am57xx-evm-fedora-node am57xx-evm-fedora-python am57xx-evm-fedora-openjdk \
intel-quark-debian intel-quark-buildpack-deps intel-quark-golang intel-quark-node intel-quark-python intel-quark-openjdk \
intel-quark-alpine intel-quark-alpine-buildpack-deps intel-quark-alpine-golang intel-quark-alpine-node intel-quark-alpine-python intel-quark-alpine-openjdk \
apalis-imx6-debian apalis-imx6-buildpack-deps apalis-imx6-golang apalis-imx6-node apalis-imx6-python apalis-imx6-openjdk \
apalis-imx6-alpine apalis-imx6-alpine-buildpack-deps apalis-imx6-alpine-golang apalis-imx6-alpine-node apalis-imx6-alpine-python apalis-imx6-alpine-openjdk \
apalis-imx6-fedora apalis-imx6-fedora-buildpack-deps apalis-imx6-fedora-golang apalis-imx6-fedora-node apalis-imx6-fedora-python apalis-imx6-fedora-openjdk \
colibri-imx6-debian colibri-imx6-buildpack-deps colibri-imx6-golang colibri-imx6-node colibri-imx6-python colibri-imx6-openjdk \
colibri-imx6-alpine colibri-imx6-alpine-buildpack-deps colibri-imx6-alpine-golang colibri-imx6-alpine-node colibri-imx6-alpine-python colibri-imx6-alpine-openjdk \
colibri-imx6-fedora colibri-imx6-fedora-buildpack-deps colibri-imx6-fedora-golang colibri-imx6-fedora-node colibri-imx6-fedora-python colibri-imx6-fedora-openjdk \
odroid-ux3-debian odroid-ux3-buildpack-deps odroid-ux3-golang odroid-ux3-node odroid-ux3-python odroid-ux3-openjdk \
odroid-ux3-alpine odroid-ux3-alpine-buildpack-deps odroid-ux3-alpine-golang odroid-ux3-alpine-node odroid-ux3-alpine-python odroid-ux3-alpine-openjdk \
odroid-ux3-fedora odroid-ux3-fedora-buildpack-deps odroid-ux3-fedora-golang odroid-ux3-fedora-node odroid-ux3-fedora-python odroid-ux3-fedora-openjdk \
parallella-hdmi-resin-debian parallella-hdmi-resin-buildpack-deps parallella-hdmi-resin-golang parallella-hdmi-resin-node parallella-hdmi-resin-python parallella-hdmi-resin-openjdk \
parallella-hdmi-resin-alpine parallella-hdmi-resin-alpine-buildpack-deps parallella-hdmi-resin-alpine-golang parallella-hdmi-resin-alpine-node parallella-hdmi-resin-alpine-python parallella-hdmi-resin-alpine-openjdk \
parallella-hdmi-resin-fedora parallella-hdmi-resin-fedora-buildpack-deps parallella-hdmi-resin-fedora-golang parallella-hdmi-resin-fedora-node parallella-hdmi-resin-fedora-python parallella-hdmi-resin-fedora-openjdk \
cubox-i-debian cubox-i-buildpack-deps cubox-i-golang cubox-i-node cubox-i-python cubox-i-openjdk \
cubox-i-alpine cubox-i-alpine-buildpack-deps cubox-i-alpine-golang cubox-i-alpine-node cubox-i-alpine-python cubox-i-alpine-openjdk \
cubox-i-fedora cubox-i-fedora-buildpack-deps cubox-i-fedora-golang cubox-i-fedora-node cubox-i-fedora-python cubox-i-fedora-openjdk \
zc702-zynq7-debian zc702-zynq7-buildpack-deps zc702-zynq7-golang zc702-zynq7-node zc702-zynq7-python zc702-zynq7-openjdk \
zc702-zynq7-alpine zc702-zynq7-alpine-buildpack-deps zc702-zynq7-alpine-golang zc702-zynq7-alpine-node zc702-zynq7-alpine-python zc702-zynq7-alpine-openjdk \
zc702-zynq7-fedora zc702-zynq7-fedora-buildpack-deps zc702-zynq7-fedora-golang zc702-zynq7-fedora-node zc702-zynq7-fedora-python zc702-zynq7-fedora-openjdk \
vab820-quad-debian vab820-quad-buildpack-deps vab820-quad-golang vab820-quad-node vab820-quad-python vab820-quad-openjdk \
vab820-quad-alpine vab820-quad-alpine-buildpack-deps vab820-quad-alpine-golang vab820-quad-alpine-node vab820-quad-alpine-python vab820-quad-alpine-openjdk \
```


## 2017-04-11

### Changed

- Add Node v7.8.0, v6.10.2 and v4.8.2.
- Add Python v3.6.1 and update setuptools to v34.3.3.


## 2017-03-31

### Changed

- Update the way hostname is set. The entryscript will only set the hostname for ResinOS 1.x devices.
- Add `fg`command to fix the broken interactive shell when runs container locally.
- INITSYSTEM will also accept 1 or 0, true or false.


## 2017-03-27

### Added

- Add support for new board CloudConnector 01 (ccon-01) and Variscite DART-6UL(imx6ul-var-dart).

### Changed

- Update Node v7.7.3.
- Update Upboard machine name: upboard -> up-board.



## 2017-03-15

### Added

- Add support for new board Kitra710.


## 2017-02-14

### Changed

- Add gpg key for Node v7.6.x.
- Add libcrypto1.0 libssl1.0 as the dependencies for Alpine Node base images.
- Add libffi libbz2 as the dependencies for Alpine Python base images.


## 2017-03-08

### Changed

- Update Resin machine name to match with other components.
	List of updated machine names:
	raspberrypi* -> raspberry-pi*,
	beaglebone -> beaglebone-black,
	edison -> intel-edison,
	nuc -> intel-nuc,
	up-board -> upboard,
	am57xx-evm -> am571x-evm,
	intel-quark -> cybertan-ze250,
	apalis-imx6 -> apalis-imx6q,
	colibri-imx6 -> colibri-imx6dl,
	odroid-ux3 -> odroid-xu4,
	parallella-hdmi-resin -> parallella,
	cubox-i -> hummingboard,
	zc702-zynq7 -> zynq-xz702,
	vab820-quad -> via-vab820-quad.
- Add ONBUILD warning message for deprecated base images.


## 2017-03-03

### Changed

- Update Node to v4.8.0, v6.10.0 and v7.6.0.
- Update Golang to v1.7.5 and v1.8.


## 2017-03-01

### Added

- Add support for new board Upboard.

### Changed

- Update QEMU to v2.7.0-resin-rc3.


## 2017-02-13

### Changed

- Update Node to v7.5.0, v6.9.5 and v4.7.3.
- Fix issue with missing latest tag for OpenJDK images.


## 2017-02-10

### Changed

- fix issue with SIGTERM is not properly handled if INITSYSTEM not enabled.


## 2017-02-07

### Changed

- Fix unmet dependencies issue when installing package in OpenJDK base images.
- Remove custom repository from Raspberry Pi base images.


## 2017-01-24

### Added

- Add support for new board AM51X EVM.

### Changed

- Set 3.5 as the latest version for all Alpine Linux base images.
- Update Python to v3.6.0.


## 2017-01-11

### Added

- Add Aarch64 Alpine Linux base images.

### Changed

- Update Node to v4.7.1, v6.9.3 and v7.4.0.
- Update Alpine Linux 3.5.


## 2017-01-02

### Changed

- Update Node to v7.3.0 and v0.12.18.


## 2016-12-20

### Changed

- Update MRAA to v1.5.1 and UPM to v1.0.2.


## 2016-12-20

### Changed

- Update Pip to v9.0.1.


## 2016-12-15

### Changed

- Update QEMU to v2.7.0-resin-rc2.


## 2016-12-11

### Changed

- Update Go to v1.6.4 and v1.7.4.


## 2016-12-08

### Changed

- Update Node to v7.2.1, v6.9.2 and v4.7.0.


## 2016-12-01

### Changed

- Update Debian i386 Node binary with no-MMX patch.


## 2016-11-30

### Changed

- Update QEMU to v2.7.0-resin-rc1.


## 2016-11-26

### Changed

- Update OpenJDK base images.


## 2016-11-22

### Changed

- Update Artik SDK repository configuration with new URL and GPG key.


## 2016-11-15

### Changed

- Update Node to v4.6.2 and v7.1.0.


## 2016-11-01

### Changed

- Update Node to v0.10.48, v4.6.1, v6.9.1 and v7.0.0.
- Switch Node binary in i386 Node base images to in-house binary.


## 2016-10-25

### Added

- Add support for new board: Artik710.

### Changed

- Install Artik SDK in Artik family base images.
- Install zigbee in Artik family.


## 2016-10-23

### Added

- Add support for new board: intel-quark.


## 2016-10-20

### Changed

- Update Setuptools to v28.6.1.


## 2016-10-17

### Changed

- Update Node to v6.8.1.


## 2016-10-13

### Changed

- Fix issue with entry script, only redirect stdout into `/dev/null`.


## 2016-10-09

### Changed

- Install systemd in debian sid base images.


## 2016-10-07

### Changed

- Fix issue with entry script in systemd base images.


## 2016-10-06

### Changed

- Update Node to v6.7.0, v0.10.47 and v4.6.0.


## 2016-09-23

### Added

- Add support for Fedora amd64 base images.


## 2016-09-20

### Changed

- Update Node to v6.6.0.


## 2016-09-15

### Changed

- set QEMU_CPU so `uname` command will report correct information on emulation environment.


## 2016-09-14

### Added

- Add support for Java base images.


## 2016-09-07

### Changed

- Fix issue on base images with systemd. Gracefully stop user process when container stops.


## 2016-08-30

### Changed

- Update Node to v6.5.0.
- Set v6.3.1 as the latest version for debian wheezy node base images.


## 2016-08-27

### Changed

- Install findutils in all base images.


## 2016-08-25

### Added

- Add support for beaglebone green board.


## 2016-08-18

### Changed

- Update Node to v6.4.0 and v4.5.0.
- Update Golang to v1.7.


## 2016-08-15

### Added

- Add support for aarch64 debian base image.


## 2016-08-10

### Changed

- Fix pip version in Fedora Python 3 base images.


## 2016-08-08

### Changed

- Fix issue with wrong python version in fedora onbuild python base images.


## 2016-08-02

### Added

- Add support for qemux86-64 and qemux86 boards.
- Add major varion tag for Python base images.


## 2016-08-02

### Added

- Add Fedora base images for ARMv7 devices.


## 2016-07-29

### Changed

- Update Node to v6.3.1.
- Update Go to v1.6.3.
- Update Python to v2.7.12 and v3.5.2.
- Update setuptools to v25.1.1 and python-dbus to v1.2.4.



## 2016-07-26

### Changed

- Fix `which` with commands that contained spaces.
- Fix issues with the shell style CMD format, eg `CMD echo test`.
- Quote `HOSTNAME` variable to handle sensitive character in UUID.
- Fix issues with the shell style format.
- Update to 7 digits UUID in hostname to match with other serives.
- Pass PATH env var to openrc service to make sure the correct path to commands get selected.
- Fix issue with wrong PYTHONPATH on Alpine Linux Python base images.


## 2016-07-19

### Changed

- Refactor entry.sh for better use locally and on device.


## 2016-07-14

### Changed

- Integrate systemd in the barebone Debian and Raspbian base images.
- Remove systemd base images.


## 2016-07-08

### Changed

- Add missing sources.list entry for raspberrypi family base images.
- Update node to v6.3.0.


## 2016-07-04

### Changed

- Update MRAA to v1.1.1 and UPM to v0.7.2.
- Update node to v0.10.46 v0.12.15 v4.4.7 and v5.12.0.


## 2016-07-01

### Added

- Add support for new board: beaglebone-green-wifi.

### Changed

- Fix hostname too long issue.
- Fix duplicate entry for v0.10 and v0.12 in node library file.


## 2016-06-20

### Added

- Add support for Alpine Linux v3.4.

### Changed

- Update node to v6.2.2.
- Move Resin apt repository entry to `/etc/apt/sources.list.d/`.


## 2016-06-08

### Added

- Add UPM v0.7.0 to Edison base images.

### Changed

- Apply EGL fix in raspberrypi family base images.
- Update node to v6.2.1 and v4.4.5.
- Add 0, 4 and 5 as aliases in node base images.


## 2016-05-27

### Changed

- Update setuptools to v21.2.1.
- Fix wrong Python version in template files.
- Update MRAA to v1.0.0.


## 2016-05-21

### Changed

- Update node to v0.10.45, v0.12.14, v4.4.4, v5.11.1, v6.2.0.
- Update architecture on armel base images to `armv5e`.
- Update setuptools to v21.0.0.
- Update pip to v8.1.2 in Python base images.
- Clean up Golang binary after unpacking.


## 2016-05-16

### Added

- Implement INITSYSTEM (OpenRC) for Alpine Linux base images.


## 2016-04-28

### Changed

- Update Node v5.11.0 and v6.0.0.
- Update Golang to v1.5.4 and v1.6.2(latest).
- Fix name of version comparing function.


## 2016-04-22

### Added

- Add support for new boards: Samsung Artik 5 and Samsung Artik 10.


## 2016-04-20

### Changed

- Clean up ~./cache in Python base images.
- Fix Python-config symlink in Python base images.
- Add node v5.10.1 and v4.4.3.


## 2016-04-06

### Changed

- Clean up redundancies after building Python base images.
- Do not remove preinstalled dependency packages after building mraa on Edison base images.
- Fix missing RPI specific packages in Raspberry PI family base images.


## 2016-04-04

### Changed

- Rever QEMU to v2.5.0-resin-rc3.
- Update node to v0.10.44, v0.12.13, v4.4.2 and v5.10.0.


## 2016-03-31

### Added

- Add Golang onbuild base images
- Add ONBUILD warning message about systemd on wheezy base images.
- Add checksums verification for Python and Node base images.

### Changed

- Update MRAA to v0.10.1.
- Fix issue with Golang dockerfile generation script.
- Set Go v1.6 as latest.
- Update node to v0.12.12, v4.4.1 and v5.9.0.


## 2016-03-26

### Changed

- Fix empty binary url on Dockerfiles for ts7700 and raspberrypi3.
- Fix issue with certificate in Alpine Python base images.
- Update pip to v8.1.1.
- Install Python from in-house package in all Python base images.


## 2016-03-24

### Changed

- Base architecture-base images on official Docker images.
- Temporarily remove libcurl package from Alpine buildpack-deps base images.
- Add xz package to Alpine buildpack-deps base images.
- Fix issues with docker template files for Alpine node base images and library generating script.

## 2016-03-22

### Changed

- Remake directory structure to support multi distros.


## 2016-03-16

### Added

- Add Alpine Linux base images.

### Changed

- Update QEMU to v2.5.0-resin-rc4.
- Update Golang images to v1.5.3 and v1.6.


## 2016-03-12

### Changed

- Install ca-certificates in all resin base images except minimum bases.


## 2016-03-11

### Added

- Add support for new board: Raspberry PI 3.

### Changed

- Update Node versions to v5.7.1 and v4.3.2.
- Remove Node versions v4.2.x and v5.3.x.
- Drop support for Python 3.2 base images.


## 2016-03-09

### Changed

- Update Node versions on wheezy base images to v0.12.11.
- Drop support for Python 3.2 base images.


## 2016-03-05

### Changed

- Update Node versions to v0.10.43 v0.12.11 v4.3.2 v5.7.1.
- Fix duplicated tags when generating library file for Golang base images.


## 2016-03-04

### Changed

- Update Golang images to v1.5.3 (latest).
- Update pip version to v8.0.3.


## 2016-03-03

### Added

- Add checksums verification for downloads


## 2016-03-02

### Changed

- Update Golang images to v1.4.3.


## 2016-01-25

### Added

- Add armel-systemd base images.
- Add base images for new board TS7700.


## 2016-01-22

### Changed

- Update QEMU version to v2.5.0-resin-rc1.


## 2016-01-13

### Changed

- Fix bug in Python Dockerfile generating script.
- Fix missing packages in Edison Node slim images.
- Drop support for v0.12.x Node on wheezy images, the last supported version is v0.12.7.


## 2016-01-08

### Changed

- Fix improper CMD instruction parsing.


## 2016-01-07

### Added

- Add image metadata: io.resin.architecture, io.resin.qemu.version and io.resin.device-type.

### Changed

- Bump QEMU version to 2.5.0. This update fixes problem between Go and QEMU, we are able to run Go builds on x86 builders since Go v1.5.2 and QEMU 2.5.0.


## 2016-01-04

## Changed

- Bump Node.js images to v0.10.41, v0.12.9, v4.2.4, v5.3.0 (latest).
- Bump Python images to v2.7.11 (latest), v3.4.4, v3.5.1.
- Bump Golang images to v1.5.2. 
- Reduce Python images size by tidying up unnecessary packages.
- Remove specific npm version in node images.
- Fix missing pacakges for node slim images.
- Reduce image size by preventing docs/locales from being installed by apt.

## 2015-12-23

## Changed

- Fix bad error message when the CMD points to a file which does not exist.


## 2015-12-11

### Changed

- Fix issue with systemd booting logs.


## 2015-11-20

### Changed

- Fix issue with format of sha256sum file on wheezy images because old version of sha256sum requires exactly two whitespaces in the input.
- Fix issue of missing packages when using Python compiled from source and reorganize libmraa installation on edison base images.


## 2015-11-19

- Symlink /dev/pts/ptmx to /dev/ptmx as /dev/pts is mounted -o newinstance. See
  https://www.kernel.org/doc/Documentation/filesystems/devpts.txt for more
  details.


## 2015-11-13

### Changed

- Fix wrong Python version in Python2 template file.


## 2015-11-12

### Added

- Add images for new board: Apalis iMX6q.

### Changed

- Use /dev/console as the TTY device path. Fixes bug with user's Dockerfile CMD
  directive being ignored when using systemd inside their container.
- Fix issue with dependencies in Python images: installing setuptools before installing pip.


## 2015-11-11

### Added

- Add Python 3.x images (3.2, 3.3, 3.4, 3.5).

### Changed

- Remake Python images: building Python from source.


## 2015-11-10

### Added

- Add Node.js v5.0.0 images.

### Changed

- Fix issues with shadowed mount points on systemd images: remounting /dev/shm, /dev/mqueme, /dev/pts, /dev/console after mounting /dev with devtmpfs.
- Change Beaglebone repo gpg keys to the correct value.
- Bump Node.js v4.0.0 to v4.2.1.


## 2015-11-03

### Added

- Add images for new board: Colibri iMX6dl

### Changed

- Change hostname from <device-type> to <device-type>-<device uuid> (6 digit uuid).


## 2015-10-13

### Changed

- Fix Go binary file name when download.


## 2015-10-08

### Changed

- Add Golang images to base images.
- Install mandatory packages: `python-virtualenv, python-setuptools` on python images.


## 2015-09-22

### Changed

- Add images for new board: ts-4900.


## 2015-09-11

### Changed

- Add `0.10.22` as default version to node images.
- Add images for new boards: odroid-c1 odroid-ux3.
- Add Node v4.0.0 to node images.
- Fix issue with npm config on node images.


## 2015-09-09

### Changed

- Fix bug with working directory of systemd service unit.
- Add images for new boards: via-vab820-quad, zynq-xz702.

## 2015-07-31

### Changed

- Mount /sys/kernel/debug FS on edison images.


## 2015-07-31

### Changed

- Mount /sys/kernel/debug FS on edison images.


## 2015-07-25

### Changed

- Stop installing systemd on wheezy images.


## 2015-07-14

### Changed

- No longer support sid images.
- Fix expired beaglebone gpg keys.
- Install systemd on wheezy images.


## 2015-07-14

### Changed

- No longer support sid images.
- Fix expired beaglebone gpg keys.


## 2015-07-09

### Changed

- Update all image name to yocto machine name convention.


## 2015-06-11

### Changed

- Mount /dev as devtmpfs on systemd images.
- Enable udev on systemd images.
- Display warning message when no CMD command is set on node and python images.


## 2015-06-10

### Added

- Release new version of Resin base images.
