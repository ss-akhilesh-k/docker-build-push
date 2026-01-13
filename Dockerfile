# ---------- Build Stage ----------
FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -o tes .

# ---------- Runtime Stage ----------
FROM alpine:3.21

WORKDIR /app

RUN adduser -D appuser
USER appuser

COPY --from=builder /app/test .

EXPOSE 8080

CMD ["./mqtt-server"]
