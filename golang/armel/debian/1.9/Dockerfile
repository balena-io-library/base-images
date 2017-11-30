FROM resin/armel-buildpack-deps:jessie

ENV GO_VERSION 1.9.2

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-armel.tar.gz" \
	&& echo "3674a42a0d13aeb4f0ebf9a8f72c90dfd0537f6d063d43b5fba926ff31ab1d93  go1.9.2.linux-armel.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-armel.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-armel.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
