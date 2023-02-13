resource "helm_release" "cert-manager" {
  name = "cert-manager"
  namespace = kubernetes_namespace.cert-manager.metadata[0].name
  create_namespace = false
  chart = "cert-manager"
  repository = "https://charts.jetstack.io"
  version = var.cert-manager_helm_version
  values = [
    file("../../k8s/cert-manager/values.yaml")
  ]
}