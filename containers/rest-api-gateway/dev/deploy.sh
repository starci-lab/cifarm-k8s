#!/bin/bash

# Create manifest
echo "Creating rest-api-gateway manifest..."
helm template rest-api-gateway ./containers/rest-api-gateway/dev \
    > ./containers/rest-api-gateway/dev/manifest.yaml

# Delete Kubernetes secret
echo "Delete Kubernetes secret..."
kubectl delete secret rest-api-gateway-env --ignore-not-found

# Create a Kubernetes secret
echo "Creating a Kubernetes secret..."
kubectl create secret generic rest-api-gateway-env \
    --from-literal=AUTH_SERVICE_HOST=$AUTH_SERVICE_HOST \
    --from-literal=AUTH_SERVICE_PORT=$AUTH_SERVICE_PORT \
    --from-literal=REST_API_GATEWAY_PORT=$REST_API_GATEWAY_PORT \

# Deploy the rest-api-gateway
echo "Deploying the rest-api-gateway..."
kubectl apply -f ./containers/rest-api-gateway/dev/manifest.yaml -l mode=deploy

#Path: containers/rest-api-gateway/dev/deploy.sh
