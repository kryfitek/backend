data "kubectl_path_documents" "certmanager_issuers_manifest" {
  pattern = "../../k8s/cert-manager/issuers.yaml"
}

resource "kubectl_manifest" "certmanager_issuers" {
  count = length(data.kubectl_path_documents.certmanager_issuers_manifest.documents)
  yaml_body = element(data.kubectl_path_documents.certmanager_issuers_manifest.documents, count.index)
}