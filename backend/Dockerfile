FROM golang:1.18.3-alpine3.16 AS build

WORKDIR /app
COPY . .
RUN go mod download && \
    go build -o /momo-store-backend ./cmd/api


FROM alpine:3.16.0

ENV USER=momo
ENV UID=12345
ENV GID=23456
WORKDIR /
COPY --from=build /momo-store-backend /momo-store-backend
EXPOSE 8081
RUN addgroup -g "$GID" -S "$USER" && \
    adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup "$USER" \
    --no-create-home \
    --uid "$UID" \
    "$USER"
#USER $USER:$USER

EXPOSE 8081

ENTRYPOINT ["/momo-store-backend"]
