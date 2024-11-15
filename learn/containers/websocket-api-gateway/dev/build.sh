#!/bin/bash

# Create manifest
echo "Creating websocket-api-gateway manifest..."
helm template websocket-api-gateway ./containers/websocket-api-gateway/dev \
    --set containerPort=$WEBSOCKET_API_GATEWAY_PORT \
    > ./containers/websocket-api-gateway/dev/manifest.yaml

# Apply the manifest
echo "Applying websocket-api-gateway manifest..."
kubectl apply -f ./containers/websocket-api-gateway/dev/manifest.yaml -l mode=build

# Path: containers/websocket-api-gateway/dev/build.sh