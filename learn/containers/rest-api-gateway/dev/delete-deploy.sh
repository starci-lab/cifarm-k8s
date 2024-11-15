#!/bin/bash

# Delete the secret
echo "Deleting Kubernetes secret..."
kubectl delete secret rest-api-gateway-env --ignore-not-found

# Delete the existing rest-api-gateway deployment
echo "Deleting existing rest-api-gateway deployment..."
kubectl delete -f ./containers/rest-api-gateway/dev/manifest.yaml -l mode=deploy

#Path: containers/rest-api-gateway/dev/delete-deploy.sh