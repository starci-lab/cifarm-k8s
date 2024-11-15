#!/bin/bash

# Create manifest
echo "Creating websocket-api-gateway manifest..."
helm template websocket-api-gateway ./containers/websocket-api-gateway/dev \
    --set containerPort=$WEBSOCKET_API_GATEWAY_PORT \
    > ./containers/websocket-api-gateway/dev/manifest.yaml

# Delete Kubernetes secret
echo "Delete Kubernetes secret..."
kubectl delete secret websocket-api-gateway-env --ignore-not-found

# Create a Kubernetes secret
echo "Creating a Kubernetes secret..."
kubectl create secret generic websocket-api-gateway-env \
    --from-literal=WEBSOCKET_API_GATEWAY_PORT=$WEBSOCKET_API_GATEWAY_PORT \
    --from-literal=BROADCAST_SERVICE_HOST=$BROADCAST_SERVICE_HOST \
    --from-literal=ADAPTER_REDIS_HOST=$ADAPTER_REDIS_HOST

# Deploy the websocket-api-gateway
echo "Deploying the websocket-api-gateway..."
kubectl apply -f ./containers/websocket-api-gateway/dev/manifest.yaml -l mode=deploy

#Path: containers/websocket-api-gateway/dev/deploy.sh
