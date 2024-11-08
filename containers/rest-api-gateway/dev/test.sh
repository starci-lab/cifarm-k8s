#!/bin/bash

# Create manifest
echo "Creating rest-api-gateway manifest..."
helm template rest-api-gateway ./containers/rest-api-gateway/dev \
    > ./containers/rest-api-gateway/dev/manifest.yaml

# Expose the rest-api-gateway service
echo "Exposing rest-api-gateway service..."
kubectl apply -f ./containers/rest-api-gateway/dev/manifest.yaml -l mode=test

#Path: containers/rest-api-gateway/dev/test.sh
