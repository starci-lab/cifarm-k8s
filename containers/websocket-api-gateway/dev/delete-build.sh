#!/bin/bash

# Delete the existing auth-service deployment
echo "Deleting existing rest api gateway kaniko build..."
kubectl delete -f ./containers/websocket-api-gateway/dev/manifest.yaml -l mode=build

#Path: containers/websocket-api-gateway/dev/delete-build.sh