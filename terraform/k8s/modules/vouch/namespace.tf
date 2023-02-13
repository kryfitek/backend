resource "kubernetes_namespace" "vouch-proxy" {
  metadata {
    name = "vouch-proxy"
  }
}