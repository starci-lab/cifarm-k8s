#!/bin/bash

# Create manifest
echo "Creating auth-service manifest..."
helm template auth-service ./containers/auth-service/dev \
    --set clusterName=$AUTH_SERVICE_HOST \
    > ./containers/auth-service/dev/manifest.yaml

# Apply the manifest
echo "Applying auth-service manifest..."
kubectl apply -f ./containers/auth-service/dev/manifest.yaml -l mode=build

# Path: containers/auth-service/dev/build.sh