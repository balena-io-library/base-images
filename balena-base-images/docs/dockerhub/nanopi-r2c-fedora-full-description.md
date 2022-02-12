<!-- THIS IS AUTO-GENERATED CONTENT. DO NOT MANUALLY EDIT. -->

This image is part of the [balena.io][balena] base image series for IoT devices. The image is optimized for use with [balena.io][balena] and [balenaOS][balena-os], but can be used in any Docker environment running on the appropriate architecture.

![balenalogo](https://avatars2.githubusercontent.com/u/6157842?s=200&v=4).

Some notable features in `balenalib` base images:

- Helpful package installer script called `install_packages` that abstracts away the specifics of the underlying package managers. It will install the named packages with smallest number of dependencies (ignore optional dependencies), clean up the package manager medata and retry if package install fails.

- Working with dynamically plugged devices: each `balenalib` base image has a default `ENTRYPOINT` which is defined as `ENTRYPOINT ["/usr/bin/entry.sh"]`, it checks if the `UDEV` flag is set to true or not (by adding `ENV UDEV=1`) and if true, it will start `udevd` daemon and the relevant device nodes in the container /dev will appear.

For more details, please check the [features overview](https://www.balena.io/docs/reference/base-images/base-images/#features-overview) in our documentation.

# [Image Variants][variants]

The `balenalib` images come in many flavors, each designed for a specific use case.

## `:<version>` or `:<version>-run`

This is the defacto image. The `run` variant is designed to be a slim and minimal variant with only runtime essentials packaged into it.

## `:<version>-build`

The build variant is a heavier image that includes many of the tools required for building from source. This reduces the number of packages that you will need to manually install in your Dockerfile, thus reducing the overall size of all images on your system.

[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub

# How to use this image with Balena

This [guide][getting-started] can help you get started with using this base image with balena, there are also some cool [example projects][example-projects] that will give you an idea what can be done with balena.

# Supported versions and respective `Dockerfile` links :

[&#x60;35 (latest)&#x60;, &#x60;36&#x60;, &#x60;34&#x60;, &#x60;33&#x60;](https://github.com/balena-io-library/base-images/tree/master/balena-base-images/device-base/nanopi-r2c/fedora/)

For more information about this image and its history, please see the [relevant manifest file (`nanopi-r2c-fedora`)](https://github.com/balena-io-library/official-images/blob/master/library/nanopi-r2c-fedora) in the [`balena-io-library/official-images` GitHub repo](https://github.com/balena-io-library/official-images).

# How to use this image

### Create a `Dockerfile` in your app project

```dockerfile
FROM balenalib/nanopi-r2c-fedora:latest
# replace this with your application
```

You can then build and run the Docker image:

```console
$ docker build -t my-app .
$ docker run -it --rm --name my-running-app my-app
```

[example-projects]: https://www.balena.io/docs/learn/getting-started/nanopi-r2c/nodejs/#example-projects?ref=dockerhub
[getting-started]: https://www.balena.io/docs/learn/getting-started/nanopi-r2c/nodejs/?ref=dockerhub

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/balena-io-library/base-images/issues).

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/balena-io-library/base-images/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

## Documentation

Documentation for this image is stored in the [base images documentation][docs]. Check it out for list of all of our base images including many specialised ones for e.g. node, python, go, smaller images, etc.

You can also find more details about new features in `balenalib` base images in this [blog post][migration-docs]

[docs]: https://www.balena.io/docs/reference/base-images/base-images/#balena-base-images?ref=dockerhub
[variants]: https://www.balena.io/docs/reference/base-images/base-images/#run-vs-build?ref=dockerhub
[migration-docs]: https://www.balena.io/blog/new-year-new-balena-base-images/?ref=dockerhub
[balena]: https://balena.io/?ref=dockerhub
[balena-os]: https://www.balena.io/os/?ref=dockerhub