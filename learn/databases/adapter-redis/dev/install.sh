
# add bitnami repo
echo "Adding bitnami repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami

# install the adapter redis helm chart
echo "Installing adapter-redis..."
helm install adapter-redis bitnami/redis \
  --set auth.enabled=false \
  --set master.containerPorts.redis=$ADAPTER_REDIS_PORT \

# Path: databases/adapter-redis/dev/install.sh