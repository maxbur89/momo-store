# Momo Store aka Пельменная №2

<img width="900" alt="image" src="https://user-images.githubusercontent.com/9394918/167876466-2c530828-d658-4efe-9064-825626cc6db5.png">

# Доступ

http://momo-store.digibi.ru/momo-store

# Frontend

```bash
npm install
NODE_ENV=production VUE_APP_API_URL=http://localhost:8081 npm run serve
```

# Backend

```bash
go run ./cmd/api
go test -v ./...
```

# Deploy HELM

```bash
helm package helm/
helm delete momo-store
helm upgrade --install momo-store ./momo-store-1.1.3.tgz --namespace momo-store
```

# Monitoring and logs

```bash
URL для сбора метрик http://127.0.0.1:8081/metrics
```
# Установка premetheus из helm

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus --namespace prometheus
```

# Прописать версии в helm репозитории
Установка Ingress
Инструкция: https://cloud.yandex.ru/docs/managed-kubernetes/tutorials/ingress-cert-manager

```bash
# установка ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx
# установка cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.8.1/cert-manager.yaml
# сменить тип service на LoadBalancer
kubectl edit svc prometheus-server -n prometheus меняет на LoadBalancer
```

# Мониторинг

## Grafana:
URL: http://grafana.digibi.ru
Логин: admin
Пароль: adminadmin

В Grafana сделаны 2 dashboard: по приложению momo-store и кластеру k8s


## Premetheus:
http://prometheus.digibi.ru
