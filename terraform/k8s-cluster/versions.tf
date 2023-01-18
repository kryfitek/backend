terraform {
  backend "remote" {
    organization = "kryfitek"

    workspaces {
      name = "backend"
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