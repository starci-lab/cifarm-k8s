# Define an output variable for the EKS cluster name
output "cluster_name" {
  # Description of the output, which will be shown when running 'terraform output'
  description = "Name of the EKS cluster"

  # Value of the output, in this case, it references the input variable 'cluster_name'
  value       = aws_eks_cluster.eks_cluster.name
}

# Primary node group name
# This output retrieves the name of the primary node group. It assumes that the ID of the node group is in the format "arn:aws:eks:<region>:<account-id>:nodegroup/<cluster-name>/<node-group-name>".
# The 'split' function is used to split the node group ID by the colon ":" delimiter.
# The result is an array, and the `[1]` index retrieves the second element, which is the name of the node group.
output "primary_node_group_name" {
  description = "Primary node group name"  # A description to explain that this output gives the primary node group's name
  value       = split(":", aws_eks_node_group.primary_node_group.id)[1]  # Splits the ID by colon and gets the name of the node group (the second part)
}

# Secondary node group name
# Similar to the primary node group, this output retrieves the name of the secondary node group.
# The ID is split by the colon ":" character, and the second element (index 1) is returned, which corresponds to the node group name.
output "secondary_node_group_name" {
  description = "Secondary node group name"  # A description to explain that this output gives the secondary node group's name
  value       = split(":", aws_eks_node_group.secondary_node_group.id)[1]  # Splits the ID by colon and gets the name of the secondary node group
}

output "cluster_autoscaler_iam_role_arn" {
  description = "IAM role ARN for the Cluster Autoscaler"
  value       = aws_iam_role.cluster_autoscaler.arn
}