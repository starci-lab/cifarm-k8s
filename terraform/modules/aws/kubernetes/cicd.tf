# Namespace for cicd resources
resource "kubernetes_namespace" "cicd" {
  metadata {
    name = "cicd"
  }
}

locals {
  jenkins_name = "jenkins"
}

# Helm release for the Jenkins
resource "helm_release" "jenkins" {
  name       = local.jenkins_name
  repository = var.bitnami_repository
  chart      = "jenkins"
  namespace  = kubernetes_namespace.cicd.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/jenkins-values.yaml", {
      user             = var.jenkins_user,
      password         = var.jenkins_password,
      node_group_label = var.secondary_node_group_name
    })
  ]
}

locals {
  jenkins_host = "jenkins.${kubernetes_namespace.cicd.metadata[0].name}.svc.cluster.local"
  jenkins_port = 80
}
