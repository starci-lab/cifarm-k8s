
# Add bitnami repo
echo "Adding bitnami repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install the prometheus helm chart
echo "Installing prometheus..."
helm install prometheus oci://registry-1.docker.io/bitnamicharts/prometheus

#Path: monitor/prometheus/dev/install.sh