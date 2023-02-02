#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" # The directory of this script
REPO_DIR="$(dirname "$SCRIPT_DIR")" # The root directory of this repository

read -p "Do you want to destroy your K8s workloads (y/n)? " CONT
if [ "$CONT" = "y" ]; then
  echo "Approval for destroy accepted";
else
  echo "Exiting!";
  exit 1
fi

echo "Destroying 'terraform/k8s'..."
cd $REPO_DIR/terraform/k8s
terraform init || exit 1
terraform destroy -auto-approve || exit 1
echo "terraform/k8s destroyed"
echo ""

echo "Done!"