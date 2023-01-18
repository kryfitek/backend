provider "kubernetes" {
  load_config_file = "false"
  host = google_container_cluster.primary.endpoint
  username = var.CLUSTER_USERNAME
  password = var.CLUSTER_PASSWORD

  client_certificate = google_container_cluster.primary.master_auth.0.client_certificate
  client_key = google_container_cluster.primary.master_auth.0.client_key
  cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

provider "kubectl" {
  host = google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  token = google_container_cluster.primary.master_auth.0.password
  load_config_file = true
  apply_retry_count = 3
}