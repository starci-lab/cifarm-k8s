#build with kaniko, push to gcr.io
echo "Building auth-service image with kaniko..."
helm template auth-service ./containers/auth-service \
    > ./containers/auth-service/manifest.yaml

# Apply the manifest
echo "Applying auth-service manifest..."
kubectl apply -f ./containers/auth-service/manifest.yaml -l mode=build

# Path: containers/auth-service/build.sh