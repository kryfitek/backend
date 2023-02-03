data "kubectl_path_documents" "health_deployment_manifest" {
  vars = {
    ENVIRONMENT = "${var.ENVIRONMENT}"
    IMAGE_TAG = "${var.IMAGE_TAG}"
    DCR_NAME = "${var.DCR_NAME}"
    ENVIRONMENT_CONTEXT = "${var.ENVIRONMENT_CONTEXT}"
  }
  pattern = "../../k8s/containers/backend/health/deployment.yaml"
}

resource "kubectl_manifest" "health_deployment" {
  count = length(data.kubectl_path_documents.health_deployment_manifest.documents)
  yaml_body = element(data.kubectl_path_documents.health_deployment_manifest.documents, count.index)
}