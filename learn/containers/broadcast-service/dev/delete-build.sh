#!/bin/bash

# Delete the existing broadcast-service deployment
echo "Deleting existing broadcast-service kaniko build..."
kubectl delete -f ./containers/broadcast-service/dev/manifest.yaml -l mode=build

#Path: containers/broadcast-service/dev/delete-build.sh