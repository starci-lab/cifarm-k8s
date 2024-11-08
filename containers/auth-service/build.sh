#!/bin/bash

# Create manifest
echo "Creating auth-service manifest..."
helm template auth-service ./containers/auth-service \
    > ./containers/auth-service/manifest.yaml

# Apply the manifest
echo "Applying auth-service manifest..."
kubectl apply -f ./containers/auth-service/manifest.yaml -l mode=build

# Path: containers/auth-service/build.sh