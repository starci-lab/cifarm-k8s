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
    size       = "s-2vcpu-4gb"
    node_count = 2
    auto_scale = false
    //min_nodes  = 2
    //max_nodes  = 3
    labels = {
      "doks.digitalocean.com/node-pool" = var.primary_node_pool_name
    }
  }
}

data "digitalocean_kubernetes_cluster" "cluster" {
  name = var.cluster_name
  //depends_on = [ digitalocean_kubernetes_cluster.cluster ]
}
