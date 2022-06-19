# Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

## Frontend

```bash
npm install
NODE_ENV=production VUE_APP_API_URL=http://localhost:8081 npm run serve
```

## Backend

```bash
go run ./cmd/api
go test -v ./...
```

## Deploy

```bash
helm package momo-store-chart/
helm delete momo-store
helm upgrade --install momo-store ./momo-store-0.1.1.tgz --namespace betta-maksim-burunov
```
