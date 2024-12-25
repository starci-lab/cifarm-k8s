# Namespace for cicd resources
resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

locals {
  jenkins_name       = "jenkins"
  jenkins_port       = 80
  jenkins_agent_name = "jenkins-agent"
}

locals {
  gameplay_service = {
    name        = "gameplay-service-build-pipeline"  # Name of the Jenkins pipeline job
    description = "Build the gameplay service using Kaniko then push the image to Dockerhub"  # Job description
    path        = ".jenkins/builds/gameplay-service/Jenkinsfile"  # Path to the Jenkinsfile
  }
}

locals {
  jenkins_init_groovy = {
    "kubernetes-cloud.groovy" = file("${path.module}/jenkins-init-groovy/kubernetes-cloud.groovy")
    "pipeline.groovy" = templatefile("${path.module}/jenkins-init-groovy/pipeline.groovy", {
      job_name        = local.gameplay_service.name                # Inject job name
      job_description = local.gameplay_service.description         # Inject job description
      job_script_path = local.gameplay_service.path                # Inject path to Jenkinsfile
      git_repo        = var.containers_git_repository              # Git repository for the containers
      git_repo_branch = var.build_branch                           # Branch to build
    })
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
      user                 = var.jenkins_user,
      password             = var.jenkins_password,
      node_group_label     = var.secondary_node_group_name,
      init_hook_scripts_cm = kubernetes_config_map.jenkins_init_groovy.metadata[0].name
    })
  ]
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
