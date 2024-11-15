#!/bin/bash

# Create manifest
echo "Creating rest-api-gateway manifest..."
helm template rest-api-gateway ./containers/rest-api-gateway/dev \
    > ./containers/rest-api-gateway/dev/manifest.yaml

# Apply the manifest
echo "Applying rest-api-gateway manifest..."
kubectl apply -f ./containers/rest-api-gateway/dev/manifest.yaml -l mode=build

# Path: containers/rest-api-gateway/dev/build.sh