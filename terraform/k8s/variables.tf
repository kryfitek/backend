variable "PROJECT_ID" {
  default = ""
  type = string
  description = "Cloud project identification"
}

variable "REGION" {
  default = ""
  type = string
  description = "Cloud project region"
}

variable "CLUSTER_USERNAME" {
  default     = ""
  description = "Kubernetes cluster username"
}

variable "CLUSTER_PASSWORD" {
  default     = ""
  description = "Kubernetes cluster password"
}

variable "ENVIRONMENT" {
  description = "The environment context which all containers are running (dev/prod)"
  type        = string
  default     = "prod"
}

variable "FRONTEND_IMAGE_TAG" {
  description = "The image tag to use for frontend deployments"
  default     = "ui"
  type        = string
}

variable "BACKEND_IMAGE_TAG" {
  description = "The image tag to use for backend deployments"
  default     = "services"
  type        = string
}

variable "REGISTRY_USERNAME" {
  description = "The username to use for docker hub authentication"
  type        = string
}

variable "REGISTRY_PASSWORD" {
  description = "The password to use for docker hub authentication"
  type        = string
}

variable "REGISTRY_EMAIL" {
  description = "The email to use for docker hub authentication"
  type        = string
}

variable "REGISTRY_SERVER" {
  description = "The server to use for docker hub authentication"
  type        = string
}