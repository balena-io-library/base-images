FROM resin/stem-x86-32-ubuntu:latest

ENV GO_VERSION 1.6.4

RUN buildDeps='curl gcc g++ git' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/local/go \
	&& curl -SLO "https://storage.googleapis.com/golang/go$GO_VERSION.linux-386.tar.gz" \
	&& echo "d9a4524dd6192bfa180fe462a468aa92fbeb0cca4887d16a9496064ceef1e94b  go1.6.4.linux-386.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-386.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-386.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
