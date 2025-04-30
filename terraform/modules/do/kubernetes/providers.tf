provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.cluster.endpoint
  token = data.digitalocean_kubernetes_cluster.cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
  )
}

# Helm provider configuration
# The Helm provider allows the management of Helm charts on the Kubernetes cluster.
# It uses the same EKS cluster authentication information to deploy and manage Helm charts.
provider "helm" {
  kubernetes {
    host                   = data.digitalocean_kubernetes_cluster.cluster.endpoint  # Kubernetes API endpoint for the EKS cluster
    cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
    )
    token                  = data.digitalocean_kubernetes_cluster.cluster.kube_config[0].token  # The token for authenticating Helm commands to the cluster
  }
}

provider "kubectl" {
  host                   = data.digitalocean_kubernetes_cluster.cluster.endpoint  # Kubernetes API endpoint from the EKS cluster data
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
    )  # Decodes the certificate authority from the cluster data
  token                  = data.digitalocean_kubernetes_cluster.cluster.kube_config[0].token  # Authentication token for Kubernetes API access
  load_config_file       = false
}
