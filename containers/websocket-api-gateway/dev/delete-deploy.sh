#!/bin/bash

# Delete the secret
echo "Deleting Kubernetes secret..."
kubectl delete secret websocket-api-gateway-env --ignore-not-found

# Delete the existing websocket-api-gateway deployment
echo "Deleting existing websocket-api-gateway deployment..."
kubectl delete -f ./containers/websocket-api-gateway/dev/manifest.yaml -l mode=deploy

#Path: containers/websocket-api-gateway/dev/delete-deploy.sh