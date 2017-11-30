FROM resin/raspberry-pi2-alpine-buildpack-deps:3.5

ENV GO_VERSION 1.9.2

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-alpine-armhf.tar.gz" \
	&& echo "77f4c4b208942271431970106e7ecb06dc495f553895fd58512e8df0df92ac8b  go1.9.2.linux-alpine-armhf.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-alpine-armhf.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-alpine-armhf.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
