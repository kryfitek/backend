#!/bin/bash
set -e

push_images () {
  echo "Building and pushing to Docker Hub..."
  $REPO_DIR/script/build_docker_images.sh
}

k8s_apply () {
  echo -e "\nDeploying 'terraform/k8s'..."
  terraform init || exit 1
  terraform apply -auto-approve || exit 1
  echo -e "Terraform/k8s deployed\n"
}

k8s_success () {
  PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n ingress-nginx)
  echo -e "All manifests applied successfully\n"
  echo -e "LoadBalancer IP: http://$PROXY_IP"
  echo -e "Done!"
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

TF_VAR_FILE="terraform/k8s/terraform.tfvars"
if [ -f "$TF_VAR_FILE" ]; then
    echo "$TF_VAR_FILE exists"
else 
    echo "$TF_VAR_FILE does not exist! Please create it and add your project credentials. Exiting..."
    exit 1
fi

grep -i "PROJECT_ID = " $TF_VAR_FILE
if ! [[ $? -ne 1 ]]; then
  echo "Please update the '$TF_VAR_FILE' file to contain your project credentials! Exiting..."
  exit 1
else
  echo "$TF_VAR_FILE contains project credentials"
fi

echo "Building K8s resources and applying their manifests on the cluster..."
cd $REPO_DIR/terraform/k8s
set +e
while true
do
  push_images
  if [ $? -ne 0 ]; then
    echo "Failed to push to Docker Hub. Trying again... 
    Hint: press 'ctrl+c' to abort the retry loop"
    sleep 5
  else
    echo "Successfully pushed image to Docker Hub"
    break
  fi
done

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