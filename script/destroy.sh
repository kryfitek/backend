#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" # The directory of this script
REPO_DIR="$(dirname "$SCRIPT_DIR")" # The root directory of this repository

read -p "Do you want to completly destroy your K8s cluster (y/n)? " CONT
if [ "$CONT" = "y" ]; then
  echo "Approval for destroy accepted";
else
  echo "Exiting!";
  exit 1
fi

# which tfenv > /dev/null

# if [ $? -ne 0 ]; then
#   echo "Please install tfenv to continue! Exiting..."
#   exit 1
# else
#   echo "tfenv is installed"
# fi

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

# echo "Destroying 'terraform/k8s'..."
# cd $REPO_DIR/terraform/k8s
# terraform init || exit 1
# terraform destroy -auto-approve || exit 1
# echo "terraform/k8s destroyed"
# echo ""

echo "Destroying 'terraform/k8s-cluster'..."
cd $REPO_DIR/terraform/k8s-cluster
terraform init || exit 1
terraform destroy -auto-approve || exit 1
echo -e "terraform/k8s-cluster destroyed\n"

echo "Done!"