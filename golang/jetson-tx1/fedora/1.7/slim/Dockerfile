FROM resin/jetson-tx1-fedora:latest

ENV GO_VERSION 1.7.5
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN buildDeps='gcc gcc-c++ git' \
	&& set -x \
	&& dnf install -y $buildDeps \
	&& dnf clean all \
	&& mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-aarch64.tar.gz" \
	&& echo "ad531f420f8fd2db2b506ec2683760be7a223af6e995122040526504b11a736c  go1.7.5.linux-aarch64.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-aarch64.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm go$GO_VERSION.linux-aarch64.tar.gz \
	&& mkdir -p "$GOPATH/src" "$GOPATH/bin" \
	&& chmod -R 777 "$GOPATH"

WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
