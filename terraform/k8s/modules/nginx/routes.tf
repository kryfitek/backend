data "kubectl_file_documents" "nginx_routes_manifests" {
  content = file("../../k8s/nginx/routes.yaml")
}

resource "kubectl_manifest" "nginx_routes" {
  count = length(data.kubectl_file_documents.nginx_routes_manifests.documents)
  yaml_body = element(data.kubectl_file_documents.nginx_routes_manifests.documents, count.index)
}