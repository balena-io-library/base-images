# AUTOGENERATED FILE
FROM balenalib/orange-pi-zero-fedora:36-run

ENV GO_VERSION 1.19.6

# gcc for cgo
RUN dnf install -y \
		gcc-c++ \
		gcc \
		git \
	&& dnf clean all

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-armv7hf.tar.gz" \
	&& echo "e415bd7265c47fe550ee64219cd28cec1b115856cb6711df75c2a6b43e020545  go$GO_VERSION.linux-armv7hf.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-armv7hf.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-armv7hf.tar.gz

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

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo $'Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: ARM v7 \nOS: Fedora 36 \nVariant: run variant \nDefault variable(s): UDEV=off \nThe following software stack is preinstalled: \nGo v1.19.6 \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info