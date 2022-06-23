{{/* Generate basic annotations for k8s */}}
{{- define "momo-store.annotations.k8s" }}
prometheus.io/scrape: "true"
prometheus.io/path: /metrics
prometheus.io/port: "8081"
{{- end }}
