FROM resin/cybertan-ze250-ubuntu-buildpack-deps:latest

ENV GO_VERSION 1.7.5

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-i386.tar.gz" \
	&& echo "182ef3f04aba98d89c8ad330ca2a895a4179f81dac6840c9293f5feda2739a0b  go1.7.5.linux-i386.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-i386.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-i386.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
