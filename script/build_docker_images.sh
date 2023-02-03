#!/bin/bash
set -e

# Global Directory Variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

cd $REPO_DIR/terraform/k8s-cluster
cd $REPO_DIR

echo "Building images and push them..."
DCR_NAME="kryfitek"
# echo "Logging into Docker Hub: $DCR_NAME"
# docker login -u kryfitek
echo "Pushing backend image..."
docker build -t $DCR_NAME/health:latest $REPO_DIR/src/backend/health
docker push $DCR_NAME/health:latest
echo "Successfully pushed the backend image"