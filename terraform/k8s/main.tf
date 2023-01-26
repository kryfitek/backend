module "kong" {
  source = "./modules/kong"
}

module "monitoring" {
  source = "./modules/monitoring"
  kube-version = "36.2.0"
}

# module "frontend" {
#   source = "./modules/containers/frontend"
#   IMAGE_TAG   = var.FRONTEND_IMAGE_TAG
#   ENVIRONMENT = var.ENVIRONMENT
# }

# module "backend" {
#   source = "./modules/containers/backend"
#   IMAGE_TAG   = var.BACKEND_IMAGE_TAG
#   ENVIRONMENT = var.ENVIRONMENT
# }