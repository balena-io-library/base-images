FROM resin/intel-nuc-fedora-buildpack-deps:25

ENV GO_VERSION 1.10.2

RUN mkdir -p /usr/local/go \
	&& curl -SLO "https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz" \
	&& echo "4b677d698c65370afa33757b6954ade60347aaca310ea92a63ed717d7cb0c2ff  go1.10.2.linux-amd64.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-amd64.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-amd64.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
