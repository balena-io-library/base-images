FROM resin/artik10-fedora:latest

ENV GO_VERSION 1.9.2
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN buildDeps='gcc gcc-c++ git' \
	&& set -x \
	&& dnf install -y $buildDeps \
	&& dnf clean all \
	&& mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-armv7hf.tar.gz" \
	&& echo "b7ced5e75a025d25753b3480c54ba63ff74f479ad057f672a7334193236aeb2f  go1.9.2.linux-armv7hf.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-armv7hf.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm go$GO_VERSION.linux-armv7hf.tar.gz \
	&& mkdir -p "$GOPATH/src" "$GOPATH/bin" \
	&& chmod -R 777 "$GOPATH"

WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
