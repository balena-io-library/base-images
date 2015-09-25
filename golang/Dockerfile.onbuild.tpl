FROM #{FROM}

RUN mkdir -p /go/src/app
WORKDIR /go/src/app

ONBUILD COPY . /go/src/app
ONBUILD RUN go-wrapper download
ONBUILD RUN go-wrapper install

# this will ideally be built by the ONBUILD below ;)
CMD ["go-wrapper", "run"]
