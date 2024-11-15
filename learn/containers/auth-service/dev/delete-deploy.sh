#!/bin/bash

# Delete the secret
echo "Deleting Kubernetes secret..."
kubectl delete secret auth-service-env --ignore-not-found

# Delete the existing auth-service deployment
echo "Deleting existing auth-service deployment..."
kubectl delete -f ./containers/auth-service/dev/manifest.yaml -l mode=deploy

#Path: containers/auth-service/dev/delete-deploy.sh