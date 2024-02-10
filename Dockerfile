FROM golang:1.20.5-buster AS builder
RUN useradd -u 10001 scratchuser

WORKDIR /go/src/app
COPY main.go .
COPY go.sum .
COPY go.mod .
RUN go build -o main main.go 

FROM gcr.io/distroless/base-debian10
COPY --from=builder /go/src/app/main /go/bin/main
COPY --from=builder /etc/passwd /etc/passwd
ENV PATH="/go/bin:${PATH}"
EXPOSE 8080

USER scratchuser
CMD ["main"]
