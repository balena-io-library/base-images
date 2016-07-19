# Resin.io systemd base images

## Description
This repository contains Dockerfiles of the Resin systemd base images. The images are organised as a tree structure to serve each device type supported by Resin. For more details on how the images fit together as a tree, see the full document: [Resin Base Images][resin-image-trees]

## Directory Structure

![Directory Structure Diagram](/img/dir_order.jpg)

* Architecture-base: The bare bones OS image for each architecture type.
* Device-base: The bare bones OS image for each device type.
* Buildpack-deps: The buildpack-deps image for each device type. Details about buildpack-deps can be found [here][resin-buildpack-deps-link]
* Node: The Node.js buildpack image for Node.js apps for each device type. Details about the Node.js image can be found [here][resin-node-link]
* Python: The Python buildpack image for Python apps for each device type.
* Golang: The Golang buildpack image for Go apps for each device type. Details about the Golang image can be found [here][resin-golang-link]

## Contribute

- Issue Tracker: [github.com/resin-io-library/base-images/issues][issue-tracker]
- Source Code: [github.com/resin-io-library/base-images][source-code]

## Support

If you're having any problem, please [raise an issue][issue-tracker] on GitHub.

## Related Resources

* [Armv6 base image][rpi-raspbian] (Ex: raspberry pi).
* [Armv7 base image][armv7-debian] (Ex: raspberry pi 2, beaglebone black, via-vab820-quad, zynq-xz702).
* [i386 base image][i386-debian] (Ex: intel edison).
* [amd64 base image][amd64-debian] (Ex: intel nuc)

[resin-image-trees]:http://docs.resin.io/#/pages/runtime/resin-base-images.md
[resin-buildpack-deps-link]:http://docs.resin.io/#/pages/runtime/resin-base-images.md#buildpack-deps
[resin-node-link]:http://docs.resin.io/#/pages/runtime/resin-base-images.md#node
[resin-golang-link]:http://docs.resin.io/#/pages/runtime/resin-base-images.md#golang
[source-code]:https://github.com/resin-io-library/base-images
[issue-tracker]:https://github.com/resin-io-library/base-images/issues
[i386-debian]:https://github.com/resin-io-library/resin-i386-debian
[armv7-debian]:https://github.com/resin-io-library/resin-armhfv7-debian
[rpi-raspbian]:https://github.com/resin-io-library/resin-rpi-raspbian
[amd64-debian]:https://github.com/resin-io-library/resin-amd64-debian
