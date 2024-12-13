# Retrieve EKS cluster configuration
# This data block fetches the details of an existing Amazon EKS cluster by its name.
# It includes configuration details such as endpoint, certificate authority, etc.
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name  # Fetches the EKS cluster configuration using the cluster name from the variable
  depends_on = [ module.eks.cluster_name ]
}

# Retrieve EKS cluster auth configuration
# This data block retrieves the authentication configuration for the EKS cluster.
# It provides the necessary authentication token to interact with the Kubernetes API of the cluster.
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name  # Retrieves the authentication token for the specified cluster
  depends_on = [ module.eks.cluster_name ]
}

# Kubernetes provider configuration
# This provider configuration allows Terraform to interact with the Kubernetes API of the EKS cluster.
# It uses the endpoint, certificate authority, and authentication token to authenticate and manage Kubernetes resources.
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint  # Kubernetes API endpoint from the EKS cluster data
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)  # Decodes the certificate authority from the cluster data
  token                  = data.aws_eks_cluster_auth.cluster.token  # Authentication token for Kubernetes API access
}

# Helm provider configuration
# The Helm provider allows the management of Helm charts on the Kubernetes cluster.
# It uses the same EKS cluster authentication information to deploy and manage Helm charts.
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint  # Kubernetes API endpoint for the EKS cluster
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)  # Decodes the certificate authority for the Helm provider
    token                  = data.aws_eks_cluster_auth.cluster.token  # The token for authenticating Helm commands to the cluster
  }
}