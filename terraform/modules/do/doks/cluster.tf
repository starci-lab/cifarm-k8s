data "digitalocean_kubernetes_versions" "versions" {
  version_prefix = var.cluster_version
}

# Create a new Kubernetes cluster
resource "digitalocean_kubernetes_cluster" "cluster" {
  name   = var.cluster_name
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = var.cluster_version
  auto_upgrade = true
  node_pool {
    name       = var.primary_node_pool_name
    size       = var.primary_node_size
    node_count = var.primary_node_count
    auto_scale = var.primary_node_auto_scale
    //min_nodes  = 2
    //max_nodes  = 3
    labels = {
      "doks.digitalocean.com/node-pool" = var.primary_node_pool_name
    }
  }
}
