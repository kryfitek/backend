terraform {
  backend "remote" {
    organization = "kryfitek"

    workspaces {
      name = "k8s-workloads"
    }
  }

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}