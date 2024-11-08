#!/bin/bash

# Delete the existing auth-service deployment
echo "Deleting existing auth-service kaniko build..."
kubectl delete -f ./containers/auth-service/dev/manifest.yaml -l mode=build

#Path: containers/auth-service/dev/delete-build.sh