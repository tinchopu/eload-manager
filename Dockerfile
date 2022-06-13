FROM golang:1.18.3-buster AS builder

ARG VERSION=dev
ENV GIN_MODE=release
WORKDIR /go/src/app
COPY main.go .
COPY go.sum .
COPY go.mod .
RUN go build -o main -ldflags=-X=main.version=${VERSION} main.go 

FROM debian:buster-slim
COPY --from=builder /go/src/app/main /go/bin/main
ENV PATH="/go/bin:${PATH}"
EXPOSE 8080
CMD ["main"]
