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

# What is Go?

Go (a.k.a., Golang) is a programming language first developed at Google. It is a statically-typed language with syntax loosely derived from C, but with additional features such as garbage collection, type safety, some dynamic-typing capabilities, additional built-in types (e.g., variable-length arrays and key-value maps), and a large standard library.

> [wikipedia.org/wiki/Go_(programming_language)](http://en.wikipedia.org/wiki/Go_%28programming_language%29)

![logo](https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/golang/logo.png)

# Supported versions and respective `Dockerfile` links :

[&#x60;1.6 (latest)&#x60;, &#x60;1.15.8&#x60;, &#x60;1.14.14&#x60;](https://github.com/balena-io-library/base-images/tree/master/balena-base-images/golang/raspberry-pi2/alpine/)

For more information about this image and its history, please see the [relevant manifest file (`raspberry-pi2-alpine-golang`)](https://github.com/balena-io-library/official-images/blob/master/library/raspberry-pi2-alpine-golang) in the [`balena-io-library/official-images` GitHub repo](https://github.com/balena-io-library/official-images).

# How to use this image

## Start a Go instance in your app

The most straightforward way to use this image is to use a Go container as both the build and runtime environment. In your `Dockerfile`, writing something along the lines of the following will compile and run your project:

```dockerfile
FROM balenalib/raspberry-pi2-alpine-golang:latest

WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["app"]
```

You can then build and run the Docker image:

```console
$ docker build -t my-golang-app .
$ docker run -it --rm --name my-running-app my-golang-app
```

## Compile your app inside the Docker container

There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the Docker instance, you can write something like:

```console
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp balenalib/raspberry-pi2-alpine-golang:latest go build -v
```

This will add your current directory as a volume to the container, set the working directory to the volume, and run the command `go build` which will tell go to compile the project in the working directory and output the executable to `myapp`.

[example-projects]: https://www.balena.io/docs/learn/getting-started/raspberry-pi2/go/#example-projects?ref=dockerhub
[getting-started]: https://www.balena.io/docs/learn/getting-started/raspberry-pi2/go/?ref=dockerhub

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