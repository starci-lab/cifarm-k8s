# Namespace for cicd resources
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

locals {
  jenkins_name = "jenkins"
  jenkins_port = 80
  jenkins_agent_name = "jenkins-agent"
}

locals {
  jenkins_init_groovy = {
    "kubernetes-cloud.groovy" = file("${path.module}/jenkins-init-groovy/kubernetes-cloud.groovy")
  }
}

resource "kubernetes_config_map" "jenkins_init_groovy" {
  metadata {
    name      = "jenkins-init-groovy"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
  
  data = local.jenkins_init_groovy
}

# Helm release for the Jenkins
resource "helm_release" "jenkins" {
  name       = local.jenkins_name
  repository = var.bitnami_repository
  chart      = "jenkins"
  namespace  = kubernetes_namespace.jenkins.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/jenkins-values.yaml", {
      user             = var.jenkins_user,
      password         = var.jenkins_password,
      node_group_label = var.secondary_node_group_name
    })
  ]

  dynamic "set" {
    for_each = local.jenkins_init_groovy
    content {
      name  = "initHookScripts.${replace(set.key, ".", "\\.")}"
      value = set.value
    }
  }
}

locals {
  jenkins_host = "jenkins.${kubernetes_namespace.jenkins.metadata[0].name}.svc.cluster.local"
}

//Create RBAC for Jenkins agent
resource "kubernetes_service_account" "jenkins" {
  metadata {
    name      = local.jenkins_agent_name
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
}

resource "kubernetes_role" "jenkins" {
  metadata {
    name = local.jenkins_agent_name
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log"]
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }
}

resource "kubernetes_role_binding" "jenkins" {
  metadata {
    name = local.jenkins_agent_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_role.jenkins.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins.metadata[0].name
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }
}