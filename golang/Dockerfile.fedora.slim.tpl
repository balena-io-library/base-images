FROM #{FROM}

ENV GO_VERSION #{GO_VERSION}
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN buildDeps='gcc gcc-c++ git' \
	&& set -x \
	&& dnf install -y $buildDeps \
	&& dnf clean all \
	&& mkdir -p /usr/local/go \
	&& curl -SLO "#{BINARY_URL}" \
	&& echo "#{CHECKSUM}" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-#{TARGET_ARCH}.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm go$GO_VERSION.linux-#{TARGET_ARCH}.tar.gz \
	&& mkdir -p "$GOPATH/src" "$GOPATH/bin" \
	&& chmod -R 777 "$GOPATH"

WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
