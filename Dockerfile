# build Oragono
FROM golang:alpine AS builder

RUN apk update
RUN apk upgrade
RUN apk add git

RUN mkdir -p /go/src/github.com/oragono
WORKDIR /go/src/github.com/oragono

RUN git clone -b stable https://github.com/oragono/oragono.git
WORKDIR /go/src/github.com/oragono/oragono
RUN git submodule update --init

# compile
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s" -o build/docker/oragono oragono.go

# run in a lightweight distro
FROM alpine

# install latest updates and configure alpine
RUN apk update
RUN apk upgrade
RUN mkdir /lib/modules

# standard ports listened on
EXPOSE 6667/tcp 6697/tcp

# prep and copy oragono from build environment
RUN mkdir -p /ircd/languages
WORKDIR /ircd
COPY --from=builder /go/src/github.com/oragono/oragono/build/docker/ .
COPY --from=builder /go/src/github.com/oragono/oragono/languages/ ./languages/
COPY --from=builder /go/src/github.com/oragono/oragono/oragono.yaml /config/ircd.yaml
COPY --from=builder /go/src/github.com/oragono/oragono/oragono.motd /config/ircd.motd

# init
RUN ./oragono initdb --conf /config/ircd.yaml
RUN ./oragono mkcerts --conf /config/ircd.yaml

# launch
CMD ./oragono run --conf /config/ircd.yaml
