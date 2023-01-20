data "terraform_remote_state" "k8s_cluster" {
  backend = "remote"

  config = {
    organization = "kryfitek"
    workspaces = {
      name = "backend"
    }
  }
}
data "google_client_config" "default" {
}

data "google_container_cluster" "cluster" {
  name = data.terraform_remote_state.k8s_cluster.outputs.kubernetes_cluster_name
  location = data.terraform_remote_state.k8s_cluster.outputs.region
  project = data.terraform_remote_state.k8s_cluster.outputs.project_id
}

provider "kubernetes" {
  load_config_file = "false"
  host = data.google_container_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
  )
  token = data.google_client_config.default.access_token
}

provider "kubectl" {
  host = data.google_container_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
  )
  token = data.google_client_config.default.access_token
  load_config_file = true
  apply_retry_count = 3
}