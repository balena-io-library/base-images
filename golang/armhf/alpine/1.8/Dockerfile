FROM resin/armhf-alpine-buildpack-deps:latest

ENV GO_VERSION 1.8.5

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-alpine-armhf.tar.gz" \
	&& echo "68f60ebf5f3d6a11e80497a0007cec4467a907551655be2d28e7ea1468d80df0  go1.8.5.linux-alpine-armhf.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-alpine-armhf.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-alpine-armhf.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
