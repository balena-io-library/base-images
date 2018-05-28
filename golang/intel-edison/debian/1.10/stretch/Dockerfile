FROM resin/intel-edison-buildpack-deps:stretch

ENV GO_VERSION 1.10.2

RUN mkdir -p /usr/local/go \
	&& curl -SLO "https://storage.googleapis.com/golang/go$GO_VERSION.linux-386.tar.gz" \
	&& echo "ea4caddf76b86ed5d101a61bc9a273be5b24d81f0567270bb4d5beaaded9b567  go1.10.2.linux-386.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-386.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-386.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
