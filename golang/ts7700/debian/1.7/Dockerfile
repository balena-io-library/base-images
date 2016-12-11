FROM resin/ts7700-buildpack-deps:jessie

ENV GO_VERSION 1.7.4

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-armel.tar.gz" \
	&& echo "dc7ccc9dccfe7f2cdd70894f2ce1e249d3cd48a85bf58cafaa5d05b2b3a32f09  go1.7.4.linux-armel.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-armel.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-armel.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
