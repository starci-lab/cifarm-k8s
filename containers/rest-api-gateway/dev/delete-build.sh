#!/bin/bash

# Delete the existing auth-service deployment
echo "Deleting existing rest api gateway kaniko build..."
kubectl delete -f ./containers/rest-api-gateway/dev/manifest.yaml -l mode=build

#Path: containers/rest-api-gateway/dev/delete-build.sh