provider "google" {
  project = var.PROJECT_ID
  region  = var.REGION
}

resource "google_compute_network" "vpc" {
  name                    = "${var.PROJECT_ID}-vpc-${var.ENVIRONMENT}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.PROJECT_ID}-subnet-${var.ENVIRONMENT}"
  region        = var.REGION
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}