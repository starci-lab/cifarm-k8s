# Delete the existing auth-service deployment
echo "Deleting existing auth-service deployment..."
kubectl delete -f ./containers/auth-service/manifest.yaml -l mode=build

#Path: containers/auth-service/delete-build.sh