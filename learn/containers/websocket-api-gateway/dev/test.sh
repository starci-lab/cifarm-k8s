#!/bin/bash

# Create manifest
echo "Creating websocket-api-gateway manifest..."
helm template websocket-api-gateway ./containers/websocket-api-gateway/dev \
    > ./containers/websocket-api-gateway/dev/manifest.yaml

# Expose the websocket-api-gateway service
echo "Exposing websocket-api-gateway service..."
kubectl apply -f ./containers/websocket-api-gateway/dev/manifest.yaml -l mode=test

#Path: containers/websocket-api-gateway/dev/test.sh
