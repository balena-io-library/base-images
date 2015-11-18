# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## 2015-11-18

### Changed

- Mount devtmpfs _over_ `/dev/pts` to avoid `/dev/ptmx` misbehaving and . See commit
  message for more gory details.

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
- Pump Node.js v4.0.0 to v4.2.1.


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
