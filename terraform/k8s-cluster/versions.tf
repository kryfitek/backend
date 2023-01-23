terraform {
  backend "remote" {
    organization = "kryfitek"

    workspaces {
      name = "k8s-cluster"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }

  required_version = ">= 0.14"
}