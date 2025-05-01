# Output the cluster name
output "cluster_name" {
  description = "The name of the cluster"
  value = digitalocean_kubernetes_cluster.cluster.name  # The ID of the VPC resource, which is created or referenced earlier in the configuration
}

# Output the primary node pool name
output "primary_node_pool_name" {
  description = "The name of the primary node pool"  
  value = digitalocean_kubernetes_cluster.cluster.node_pool[0].name  # A list comprehension that collects the 'id' of each subnet in the 'private_subnets' collection
}