FROM resin/nuc-fedora:latest

ENV GO_VERSION 1.7
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN buildDeps='gcc gcc-c++ git' \
	&& set -x \
	&& dnf install -y $buildDeps \
	&& dnf clean all \
	&& mkdir -p /usr/local/go \
	&& curl -SLO "https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz" \
	&& echo "702ad90f705365227e902b42d91dd1a40e48ca7f67a2f4b2fd052aaa4295cd95  go1.7.linux-amd64.tar.gz" | sha256sum -c - \
	&& tar -xzf "go$GO_VERSION.linux-amd64.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm go$GO_VERSION.linux-amd64.tar.gz \
	&& mkdir -p "$GOPATH/src" "$GOPATH/bin" \
	&& chmod -R 777 "$GOPATH"

WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: http://docs.resin.io/deployment/dockerfile"]
