# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

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
