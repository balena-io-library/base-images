# AUTOGENERATED FILE
FROM balenalib/revpi-core-3-alpine:3.15-run

ENV GO_VERSION 1.18.10

# set up nsswitch.conf for Go's "netgo" implementation
# - https://github.com/golang/go/blob/go1.9.1/src/net/conf.go#L194-L275
# - docker run --rm debian:stretch grep '^hosts:' /etc/nsswitch.conf
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf || true

# gcc for cgo
RUN apk add --no-cache git gcc ca-certificates

RUN fetchDeps='curl' \
	&& set -x \
	&& apk add --no-cache $fetchDeps \
	&& mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-alpine-armv7hf.tar.gz" \
	&& echo "4feff63a7e89e3d9df555e3dbcd02fc3c475acf991b4210838d5858e7b8895ce  go$GO_VERSION.linux-alpine-armv7hf.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-alpine-armv7hf.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-alpine-armv7hf.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: https://balena.io/docs"]

 RUN curl -SLO "https://raw.githubusercontent.com/balena-io-library/base-images/613d8e9ca8540f29a43fddf658db56a8d826fffe/scripts/assets/tests/test-stack@golang.sh" \
  && echo "Running test-stack@golang" \
  && chmod +x test-stack@golang.sh \
  && bash test-stack@golang.sh \
  && rm -rf test-stack@golang.sh 

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo $'This base image is deprecated and will no longer receive updates. Refer to our blog post (https://blog.balena.io/deprecate-balenalib-images/) for migration guidance and suggested alternatives. \nHere are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: ARM v7 \nOS: Alpine Linux 3.15 \nVariant: run variant \nDefault variable(s): UDEV=off \nThe following software stack is preinstalled: \nGo v1.18.10 \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info