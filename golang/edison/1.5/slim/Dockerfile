FROM resin/edison-debian:jessie

ENV GO_VERSION 1.5.1

RUN buildDeps='curl gcc g++ git' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -SLO "https://storage.googleapis.com/golang/go$GO_VERSION.linux-386.tar.gz" \
	&& mkdir -p /usr/local/go \
	&& tar -xzf "go-v$GO_VERSION-linux-386.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm "go-v$GO_VERSION-linux-386.tar.gz"

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/#/pages/using/dockerfile.md"]
