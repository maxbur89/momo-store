FROM golang:1.18.3-alpine3.16 AS build

WORKDIR /app
COPY . .
RUN go mod download && \
    CGO_ENABLED=0 go build -o /momo-store-backend ./cmd/api


FROM scratch

COPY --from=build /momo-store-backend /momo-store-backend

ENTRYPOINT ["/momo-store-backend"]

EXPOSE 8081
