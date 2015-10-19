# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

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
