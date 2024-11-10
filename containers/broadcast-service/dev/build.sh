#!/bin/bash

# Create manifest
echo "Creating broadcast-service manifest..."
helm template broadcast-service ./containers/broadcast-service/dev \
    --set clusterName=$BROADCAST_SERVICE_HOST \
    > ./containers/broadcast-service/dev/manifest.yaml

# Apply the manifest
echo "Applying broadcast-service manifest..."
kubectl apply -f ./containers/broadcast-service/dev/manifest.yaml -l mode=build

# Path: containers/broadcast-service/dev/build.sh