FROM resin/qemux86-64-alpine-buildpack-deps:latest

ENV GO_VERSION 1.7.5

RUN mkdir -p /usr/local/go \
	&& curl -SLO "http://resin-packages.s3.amazonaws.com/golang/v$GO_VERSION/go$GO_VERSION.linux-alpine-amd64.tar.gz" \
	&& echo "0b067f4986c76486e5de65ac21c660cca586851f0a5f41adee4c6f5e492774f9  go1.7.5.linux-alpine-amd64.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-alpine-amd64.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.linux-alpine-amd64.tar.gz

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
ONBUILD RUN echo 'This repository is deprecated. Please check https://docs.resin.io/runtime/resin-base-images/ for information about Resin docker images.' 
