#!/bin/bash

# Create manifest
echo "Creating auth-service manifest..."
helm template auth-service ./containers/auth-service/dev \
    > ./containers/auth-service/dev/manifest.yaml

# Delete Kubernetes secret
echo "Delete Kubernetes secret..."
kubectl delete secret auth-service-env --ignore-not-found

# Create a Kubernetes secret
echo "Creating a Kubernetes secret..."
kubectl create secret generic auth-service-env \
    --from-literal=GAMEPLAY_POSTGRES_USER="postgres" \
    --from-literal=GAMEPLAY_POSTGRES_PASS=$GAMEPLAY_POSTGRES_PASSWORD \
    --from-literal=GAMEPLAY_POSTGRES_HOST="gameplay-postgres-postgresql-ha-pgpool" \
    --from-literal=GAMEPLAY_POSTGRES_PORT=$GAMEPLAY_POSTGRES_PORT \
    --from-literal=GAMEPLAY_POSTGRES_DBNAME=$GAMEPLAY_POSTGRES_DATABASE \
    --from-literal=CACHE_REDIS_HOST="cache-redis-master" \
    --from-literal=CACHE_REDIS_PORT=$CACHE_REDIS_PORT \

# Deploy the auth-service
echo "Deploying the auth-service..."
kubectl apply -f ./containers/auth-service/dev/manifest.yaml -l mode=deploy

#Path: containers/auth-service/dev/deploy.sh
