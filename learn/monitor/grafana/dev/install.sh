
# Add bitnami repo
echo "Adding bitnami repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install the prometheus helm chart
echo "Installing grafana..."
helm install grafana oci://registry-1.docker.io/bitnamicharts/grafana \
    --set admin.user=$GRAFANA_ADMIN_USER \
    --set admin.password=$GRAFANA_ADMIN_PASSWORD \
    --set metrics.enabled=true

#Path: monitor/grafana/dev/install.sh