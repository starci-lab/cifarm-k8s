
# Add bitnami repo
echo "Adding bitnami repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install the prometheus helm chart
echo "Installing prometheus..."
helm install prometheus oci://registry-1.docker.io/bitnamicharts/prometheus \
    --set server.service.type=ClusterIP \
    --set alertmanager.service.type=ClusterIP \
    --set alertmanager.resources.requests.memory=256Mi \
    --set alertmanager.resources.requests.cpu=250m \
    --set alertmanager.resources.limits.memory=512Mi \
    --set alertmanager.resources.limits.cpu=500m \
    --set server.resources.requests.memory=256Mi \
    --set server.resources.requests.cpu=250m \
    --set server.resources.limits.memory=512Mi \
    --set server.resources.limits.cpu=500m \
    --set server.thanos.resources.requests.memory=256Mi \
    --set server.thanos.resources.requests.cpu=500m \
    --set server.thanos.resources.limits.memory=256Mi \
    --set server.thanos.resources.limits.cpu=500m

#Path: learn/monitor/prometheus/dev/install.sh