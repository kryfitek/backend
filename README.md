# backend
Backend for kryfitek platform

## Prometheus
kubectl port-forward svc/kube-prometheus-stackr-prometheus 9090:9090 --namespace monitoring

`http://localhost:9090/`

## Grafana
kubectl port-forward svc/kube-prometheus-stackr-grafana 3000:80 --namespace monitoring

`http://localhost:3000/`

## Alertmanager
kubectl port-forward svc/kube-prometheus-stackr-alertmanager 9093:9093 --namespace monitoring

`http://localhost:9093/`