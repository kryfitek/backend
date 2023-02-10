resource "kubernetes_secret" "docker" {
  metadata {
    name = "dockerhub"
    namespace = "backend"
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.REGISTRY_SERVER}" = {
          "username" = var.REGISTRY_USERNAME
          "password" = var.REGISTRY_PASSWORD
          "email" = var.REGISTRY_EMAIL
          "auth" = base64encode("${var.REGISTRY_USERNAME}:${var.REGISTRY_PASSWORD}")
        }
      }
    })
  }
  depends_on = [
    module.backend
  ]
}

module "monitoring" {
  source = "./modules/monitoring"
  kube-version = "36.2.0"
}

module "nginx" {
  source = "./modules/nginx"
}

# module "frontend" {
#   source = "./modules/containers/frontend"
#   IMAGE_TAG   = var.FRONTEND_IMAGE_TAG
#   ENVIRONMENT = var.ENVIRONMENT
# }

module "backend" {
  source = "./modules/containers/backend"
}

module "health" {
  source = "./modules/containers/backend/health"
  ENVIRONMENT = var.ENVIRONMENT
}