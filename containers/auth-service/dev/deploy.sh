#!/bin/bash

# Create manifest
echo "Creating auth-service manifest..."
helm template auth-service ./containers/auth-service/dev \
    --set clusterName=$AUTH_SERVICE_HOST \
    --set containerPort=$AUTH_SERVICE_PORT \
    > ./containers/auth-service/dev/manifest.yaml

# Delete Kubernetes secret
echo "Delete Kubernetes secret..."
kubectl delete secret auth-service-env --ignore-not-found

# Create a Kubernetes secret
echo "Creating a Kubernetes secret..."
kubectl create secret generic auth-service-env \
    --from-literal=GAMEPLAY_POSTGRES_USER=$GAMEPLAY_POSTGRES_USERNAME \
    --from-literal=GAMEPLAY_POSTGRES_PASS=$GAMEPLAY_POSTGRES_PASS \
    --from-literal=GAMEPLAY_POSTGRES_HOST=$GAMEPLAY_POSTGRES_HOST \
    --from-literal=GAMEPLAY_POSTGRES_PORT=$GAMEPLAY_POSTGRES_PORT \
    --from-literal=GAMEPLAY_POSTGRES_DBNAME=$GAMEPLAY_POSTGRES_DBNAME \
    --from-literal=CACHE_REDIS_HOST=$CACHE_REDIS_HOST \
    --from-literal=CACHE_REDIS_PORT=$CACHE_REDIS_PORT \
    --from-literal=AUTH_SERVICE_HOST=$AUTH_SERVICE_PORT \

# Deploy the auth-service
echo "Deploying the auth-service..."
kubectl apply -f ./containers/auth-service/dev/manifest.yaml -l mode=deploy

#Path: containers/auth-service/dev/deploy.sh
