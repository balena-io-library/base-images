FROM resin/cybertan-ze250-debian:jessie

ENV GO_VERSION 1.9.6

RUN buildDeps='curl gcc g++ git' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-i386.tar.gz" \
	&& echo "b2d8962128cb3d7c6b9f2f1e9b1dc2a3de4f3245f2b9c1229d3115b3e760b9a7  go1.9.6.linux-i386.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-i386.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-i386.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
