FROM resin/resin/ts7700-debian:jessie

ENV GO_VERSION 1.5.3

RUN buildDeps='curl gcc g++ git' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-armel.tar.gz" \
	&& echo "ee34ba5af6a94526b6980b38138cad4e05d1da80b1819b4b40204490c3ae739e  go1.5.3.linux-armel.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-armel.tar.gz" -C /usr/local/go --strip-components=1

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
