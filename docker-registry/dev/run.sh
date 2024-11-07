#!/bin/bash

# This script reads Docker registry credentials from a .env.secret file and sets them up in a Kubernetes secret.

echo "Deleting previous secret..."
kubectl delete secret regcred

echo "Reading Docker registry credentials from file..."

# Read each line from .env.secret and set them as environment variables
# The format in .env.secret should be key=value
while IFS='=' read -r key value; do
  export "$key=$value"
done < .env.secret

echo "Setting up credentials for Docker registry..."

# Create the Kubernetes secret using the Docker credentials
kubectl create secret docker-registry regcred \
  --docker-server="$DOCKER_SERVER" \
  --docker-username="$DOCKER_USERNAME" \
  --docker-password="$DOCKER_PASSWORD" \
  --docker-email="$DOCKER_EMAIL"

echo "Set up complete."