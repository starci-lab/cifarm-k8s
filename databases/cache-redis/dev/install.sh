
# add bitnami repo
echo "Adding bitnami repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami

# install the cache redis helm chart
echo "Installing cache-redis..."
helm install cache-redis bitnami/redis \
  --set auth.enabled=false \
  --set master.containerPorts.redis=$CACHE_REDIS_PORT \

# Path: databases/cache-redis/dev/install.sh