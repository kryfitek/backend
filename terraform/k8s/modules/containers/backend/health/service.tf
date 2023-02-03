data "kubectl_file_documents" "health_service_manifest" {
  content = file("../../k8s/containers/backend/health/service.yaml")
}

resource "kubectl_manifest" "health_service" {
  count = length(data.kubectl_file_documents.health_service_manifest.documents)
  yaml_body = element(data.kubectl_file_documents.health_service_manifest.documents, count.index)
}