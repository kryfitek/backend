# backend
Backend for kryfitek platform

## APIs
APIs are available at:

http://api.kryfitek.com

## Prometheus
kubectl port-forward svc/kube-prometheus-stackr-prometheus 9090:9090 --namespace monitoring

http://localhost:9090

## Grafana
Available through Kong at:

http://grafana.kryfitek.com

Also available at:

## Alertmanager
kubectl port-forward svc/kube-prometheus-stackr-alertmanager 9093:9093 --namespace monitoring

http://localhost:9093