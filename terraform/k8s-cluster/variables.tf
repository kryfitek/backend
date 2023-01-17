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
  description = "The Environment context which all containers are running in (dev/prod)"
  type        = string
  default     = "prod"
}

variable "NODE_COUNT" {
  description = "Number of Nodes in your K8s cluster"
  default     = 2
  type        = number
}

variable "VM_SIZE" {
  description = "Size of the VM to create"
  default     = "e2-medium"
  type        = string
}

variable "NODE_DISK_SIZE_GB" {
  description = "The size in GB of the storage on each node"
  default     = 30
  type        = number
}