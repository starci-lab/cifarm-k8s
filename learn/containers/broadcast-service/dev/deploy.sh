#!/bin/bash

# Create manifest
echo "Creating broadcast-service manifest..."
helm template broadcast-service ./containers/broadcast-service/dev \
    --set clusterName=$BROADCAST_SERVICE_HOST \
    --set containerPort=$BROADCAST_SERVICE_PORT \
    > ./containers/broadcast-service/dev/manifest.yaml

# Delete Kubernetes secret
echo "Delete Kubernetes secret..."
kubectl delete secret broadcast-service-env --ignore-not-found

# Create a Kubernetes secret
echo "Creating a Kubernetes secret..."
kubectl create secret generic broadcast-service-env \
    --from-literal=GAMEPLAY_POSTGRES_USER=$GAMEPLAY_POSTGRES_USERNAME \
    --from-literal=GAMEPLAY_POSTGRES_PASS=$GAMEPLAY_POSTGRES_PASS \
    --from-literal=GAMEPLAY_POSTGRES_HOST=$GAMEPLAY_POSTGRES_HOST \
    --from-literal=GAMEPLAY_POSTGRES_PORT=$GAMEPLAY_POSTGRES_PORT \
    --from-literal=GAMEPLAY_POSTGRES_DBNAME=$GAMEPLAY_POSTGRES_DBNAME \

# Deploy the broadcast-service
echo "Deploying the broadcast-service..."
kubectl apply -f ./containers/broadcast-service/dev/manifest.yaml -l mode=deploy

#Path: containers/broadcast-service/dev/deploy.sh
