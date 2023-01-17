#!/bin/bash

k8s_apply () {
  echo "Deploying 'terraform/k8s'..."
  terraform init || exit 1
  terraform apply -auto-approve || exit 1
  echo "Terraform/k8s deployed"
}

k8s_success () {
  PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
  echo -e "All manifests applied successfully\n"
  echo -e "Kong LoadBalancer IP: http://$PROXY_IP"
  echo -e "Run 'script/grafana' to connect to the Kong metrics dashboard"
  echo -e "Done!"
}

# Global Directory Variables
set -e
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

# which tfenv > /dev/null
# if [ $? -ne 0 ]; then
#   echo "Please install tfenv to continue! Exiting..."
#   exit 1
# else
#   echo "tfenv is installed"
# fi

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
if [ !$? -ne 1 ]; then
  echo "Please update the '$TF_VAR_FILE' file to contain your project credentials! Exiting..."
  exit 1
else
  echo "$TF_VAR_FILE does not contain project credentials"
fi

TF_VAR_FILE="terraform/k8s/terraform.tfvars"
if [ -f "$TF_VAR_FILE" ]; then
    echo "$TF_VAR_FILE exists"
else 
    echo "$TF_VAR_FILE does not exist! Please create it and add your project credentials. Exiting..."
    exit 1
fi

grep -i "PROJECT_ID = " $TF_VAR_FILE
if [ !$? -ne 1 ]; then
  echo "Please update the '$TF_VAR_FILE' file to contain your project credentials! Exiting..."
  exit 1
else
  echo "$TF_VAR_FILE does not contain non-default credentials"
fi

echo "Deploying 'terraform/k8s-cluster'..."
set -e # Prevent any kind of script failures
cd terraform/k8s-cluster
terraform init || exit 1
terraform apply -auto-approve || exit 1
echo "terraform/k8s-cluster deployed"

echo "Configuring kubectl environment..."
K8S_CLUSTER_NAME=$(terraform output -raw kubernetes_cluster_name)
K8S_CLUSTER_REGION=$(terraform output -raw region)
gcloud container clusters get-credentials $K8S_CLUSTER_NAME --region $K8S_CLUSTER_REGION
echo "kubectl configured"

echo "Building K8s resources and applying their manifests on the cluster..."
cd $REPO_DIR/terraform/k8s
set +e
while true
do
  k8s_apply
  if [ $? -ne 0 ]; then
    echo "A possible race condition occured. Sleeping and trying again... 
    Hint: press 'ctrl+c' to abort the retry loop"
    sleep 5
  else
    k8s_success
    break
  fi
done