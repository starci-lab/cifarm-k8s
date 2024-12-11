# Cluster endpoint output
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

# Cluster security group id output
output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

# Cluster name output
output "region" {
  description = "AWS region"
  value       = var.region
}

# Cluster name output
output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

# Node group primary id output
output "node_group_primary_id" {
  description = "Primary node group ID"
  value       = module.eks.eks_managed_node_groups.primary_group.node_group_id
}

# Node group secondary id output
output "node_group_secondary_id" {
  description = "Secondary node group ID"
  value       = module.eks.eks_managed_node_groups.secondary_group.node_group_id
}

output "ebs_volume_az" {
  description = "EBS volume availability zone"
  value       = var.ebs_volume_az
}