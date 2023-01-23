#!/bin/bash
set -e

k8s_cluster_apply () {
  echo "Deploying 'terraform/k8s-cluster'..."
  set -e # Prevent any kind of script failures
  cd terraform/k8s-cluster
  terraform init || exit 1
  terraform apply -auto-approve || exit 1
  echo -e "terraform/k8s-cluster deployed\n"
}

cli_setup () {
    echo "Configuring kubectl environment..."
    K8S_CLUSTER_NAME=$(terraform output -raw kubernetes_cluster_name)
    K8S_CLUSTER_REGION=$(terraform output -raw region)
    gcloud container clusters get-credentials $K8S_CLUSTER_NAME --region $K8S_CLUSTER_REGION
    echo -e "kubectl configured\n"
}

# Global Directory Variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" # The directory of this script
REPO_DIR="$(dirname "$SCRIPT_DIR")" # The root directory of this repository

echo "Checking dependencies..."
set +e # Allow failures when checking for dependencies

which gcloud > /dev/null
if [ $? -ne 0 ]; then
  echo "Please install the Google Cloud CLI to continue! Exiting..."
  exit 1
else
  echo "google cloud CLI is installed"
fi

which kubectl > /dev/null
if [ $? -ne 0 ]; then
  echo "Please install kubectl to continue! Exiting..."
  exit 1
else
  echo "kubectl is installed"
fi

TF_VAR_FILE="terraform/k8s-cluster/terraform.tfvars"
if [ -f "$TF_VAR_FILE" ]; then
  echo "$TF_VAR_FILE exists"
else 
  echo "$TF_VAR_FILE does not exist! Please create it. Exiting..."
  exit 1
fi

grep -i "PROJECT_ID = " $TF_VAR_FILE
if ! [[ $? -ne 1 ]]; then
  echo "Please update the '$TF_VAR_FILE' file to contain your project credentials! Exiting..."
  exit 1
else
  echo "$TF_VAR_FILE contains project credentials"
fi

set -e
k8s_cluster_apply
if [ $? -eq 0 ]; then
  cli_setup
fi