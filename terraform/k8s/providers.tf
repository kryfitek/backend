data "terraform_remote_state" "k8s_cluster" {
  backend = "remote"

  config = {
    organization = "kryfitek"
    workspaces = {
      name = "k8s-cluster"
    }
  }
}

data "google_client_config" "default" {
}

data "google_container_cluster" "cluster" {
  name = data.terraform_remote_state.k8s_cluster.outputs.kubernetes_cluster_name
  location = data.terraform_remote_state.k8s_cluster.outputs.region
  project = data.terraform_remote_state.k8s_cluster.outputs.project
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.cluster.endpoint}"
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
  )
  token = data.google_client_config.default.access_token
}

provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.cluster.endpoint}"
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
    )
    token = data.google_client_config.default.access_token
  }
}