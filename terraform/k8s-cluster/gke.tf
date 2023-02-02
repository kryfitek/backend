resource "google_container_cluster" "primary" {
  name = "${var.PROJECT_ID}-gke-${var.ENVIRONMENT}"
  location = var.REGION
  remove_default_node_pool = true
  initial_node_count = 1
  network = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  node_config {
    disk_size_gb = var.NODE_DISK_SIZE_GB
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name = google_container_cluster.primary.name
  location = var.REGION
  cluster = google_container_cluster.primary.name
  node_count = var.NODE_COUNT

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.PROJECT_ID
    }

    machine_type = var.VM_SIZE
    disk_size_gb = var.NODE_DISK_SIZE_GB
    tags = ["gke-node", "${var.PROJECT_ID}-gke-${var.ENVIRONMENT}"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}