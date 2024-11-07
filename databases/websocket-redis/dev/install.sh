
# add bitnami repo
echo "Adding bitnami repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami

# install the cache redis helm chart
echo "Installing websocket-redis..."
helm install websocket-redis bitnami/redis \
  --set auth.enabled=false \
  --set master.containerPorts.redis=$CACHE_REDIS_PORT \

# Path: databases/websocket-redis/dev/install.sh