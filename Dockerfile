FROM golang:1.18.3-buster AS builder

ARG VERSION=dev
WORKDIR /go/src/app
COPY main.go .
COPY go.sum .
COPY go.mod .
ENV USER=appuser
ENV UID=10001


# See https://stackoverflow.com/a/55757473/12429735RUN 
RUN adduser \    
    --disabled-password \    
    --gecos "" \    
    --home "/nonexistent" \    
    --shell "/sbin/nologin" \    
    --no-create-home \    
    --uid "${UID}" \    
    "${USER}"

RUN go build -o main -ldflags=-X=main.version=${VERSION} main.go 

FROM scratch

# Import the user and group files from the builder.
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

COPY --from=builder /go/src/app/main /go/bin/main
USER appuser:appuser

EXPOSE 8080

ENTRYPOINT ["/go/bin/main"]


