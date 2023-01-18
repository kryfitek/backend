terraform {
  backend "remote" {
    organization = "kryfitek"

    workspaces {
      name = "backend"
    }
  }

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  required_version = "=1.0.6"
}