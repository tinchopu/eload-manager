FROM golang:1.18.3-buster AS builder
RUN useradd -u 10001 scratchuser

ARG VERSION=dev
WORKDIR /go/src/app
COPY main.go .
COPY go.sum .
COPY go.mod .
RUN CGO_ENABLED=0 go build -o main -ldflags=-X=main.version=${VERSION} main.go 

FROM scratch
COPY --from=builder /go/src/app/main /go/bin/main
COPY --from=builder /etc/passwd /etc/passwd
ENV PATH="/go/bin:${PATH}"
EXPOSE 8080

USER scratchuser
CMD ["main"]
