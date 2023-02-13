resource "helm_release" "vouch" {
  name = "vouch"
  repository = "https://halkeye.github.io/helm-charts"
  chart = "vouch"
  namespace = "vouch-proxy"
  version = var.ingress_nginx_helm_version

  values = [
    "${file("../../k8s/vouch/values.yaml")}"
  ]
}