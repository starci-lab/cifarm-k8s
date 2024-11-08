#!/bin/bash

# Delete the existing auth-service deployment
echo "Deleting existing auth-service deployment..."
kubectl delete -f ./containers/auth-service/manifest.yaml -l mode=deploy

#Path: containers/auth-service/delete-deploy.sh