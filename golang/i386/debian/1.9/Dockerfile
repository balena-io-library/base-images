FROM resin/i386-buildpack-deps:jessie

ENV GO_VERSION 1.9.4

RUN mkdir -p /usr/local/go \
	&& curl -SLO "https://storage.googleapis.com/golang/go$GO_VERSION.linux-386.tar.gz" \
	&& echo "d440aee90dad851630559bcee2b767b543ce7e54f45162908f3e12c3489888ab  go1.9.4.linux-386.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-386.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-386.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
