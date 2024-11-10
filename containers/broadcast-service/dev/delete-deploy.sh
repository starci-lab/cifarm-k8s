#!/bin/bash

# Delete the secret
echo "Deleting Kubernetes secret..."
kubectl delete secret broadcast-service-env --ignore-not-found

# Delete the existing broadcast-service deployment
echo "Deleting existing broadcast-service deployment..."
kubectl delete -f ./containers/broadcast-service/dev/manifest.yaml -l mode=deploy

#Path: containers/broadcast-service/dev/delete-deploy.sh