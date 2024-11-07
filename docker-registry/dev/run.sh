#!/bin/bash

# This script reads Docker registry credentials from a .env.secret file and sets them up in a Kubernetes secret.
echo "Deleting previous secret..."
kubectl delete secret regcred --ignore-not-found

# Create the Kubernetes secret using the Docker credentials
echo "Setting up credentials for Docker registry..."
kubectl create secret docker-registry regcred \
  --docker-server="$DOCKER_SERVER" \
  --docker-username="$DOCKER_USERNAME" \
  --docker-password="$DOCKER_PASSWORD" \
  --docker-email="$DOCKER_EMAIL"

#Path: docker-registry/dev/run.sh