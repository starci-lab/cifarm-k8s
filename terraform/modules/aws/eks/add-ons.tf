# Define an EKS add-on for the VPC CNI (Container Network Interface) plugin
# This add-on is responsible for managing networking in the EKS cluster
resource "aws_eks_addon" "vpc_cni" {
  # The EKS cluster to which the VPC CNI add-on will be associated
  cluster_name = aws_eks_cluster.eks_cluster.name
  
  # The name of the add-on, in this case, it is the VPC CNI plugin
  addon_name   = "vpc-cni"

  # Optionally specify the add-on version to ensure you're using the latest or a compatible version
  addon_version = "v1.11.0-eksbuild.1" # Replace with the latest version available if needed

  # Enable/disable the add-on as needed (defaults to enabled)
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

# Define an EKS add-on for kube-proxy
# kube-proxy is responsible for managing network rules for pods
resource "aws_eks_addon" "kube_proxy" {
  # The EKS cluster to which the kube-proxy add-on will be associated
  cluster_name = aws_eks_cluster.eks_cluster.name
  
  # The name of the add-on, which in this case is kube-proxy
  addon_name   = "kube-proxy"

  # Optionally specify the add-on version to ensure you're using the latest or a compatible version
  addon_version = "v1.24.3-eksbuild.1" # Replace with the latest version available if needed

  # Enable/disable the add-on as needed (defaults to enabled)
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

# Define an EKS add-on for CoreDNS
# CoreDNS is the default DNS service for EKS clusters, providing DNS resolution for services
resource "aws_eks_addon" "core_dns" {
  # The EKS cluster to which the CoreDNS add-on will be associated
  cluster_name = aws_eks_cluster.eks_cluster.name
  
  # The name of the add-on, which is CoreDNS
  addon_name   = "coredns"

  # Optionally specify the add-on version to ensure you're using the latest or a compatible version
  addon_version = "v1.9.0-eksbuild.1" # Replace with the latest version available if needed

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}
