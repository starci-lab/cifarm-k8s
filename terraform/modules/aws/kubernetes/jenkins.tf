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
    name        = "gameplay-service-build-pipeline"                                          # Name of the Jenkins pipeline job
    description = "Build the gameplay service using Kaniko then push the image to Dockerhub" # Job description
    path        = ".jenkins/build/gameplay-service.jenkinsfile"                             # Path to the Jenkinsfile
  }
  rest_api_gateway = {
    name        = "rest-api-gateway-build-pipeline"                                          # Name of the Jenkins pipeline job
    description = "Build the rest API gateway using Kaniko then push the image to Dockerhub" # Job description
    path        = ".jenkins/build/rest-api-gateway.jenkinsfile"                             # Path to the Jenkinsfile
  }
  gameplay_subgraph = {
    name        = "gameplay-subgraph-build-pipeline"                                          # Name of the Jenkins pipeline job
    description = "Build the gameplay subgraph using Kaniko then push the image to Dockerhub" # Job description
    path        = ".jenkins/build/gameplay-subgraph.jenkinsfile"                             # Path to the Jenkinsfile
  }
  graphql_maingraph = {
    name        = "graphql-maingraph-build-pipeline"                                          # Name of the Jenkins pipeline job
    description = "Build the graphql maingraph using Kaniko then push the image to Dockerhub" # Job description
    path        = ".jenkins/build/graphql-maingraph.jenkinsfile"                             # Path to the Jenkinsfile
  }
}

locals {
  jenkins_init_groovy_name = "jenkins-init-groovy"
  jenkins_init_groovy_cm = {
    "kubernetes-cloud.groovy" = file("${path.module}/jenkins-init-groovy/kubernetes-cloud.groovy")
    "pipeline.groovy" = templatefile("${path.module}/jenkins-init-groovy/pipeline.groovy", {
      job_name        = local.gameplay_service.name        # Inject job name
      job_description = local.gameplay_service.description # Inject job description
      job_script_path = local.gameplay_service.path        # Inject path to Jenkinsfile
      git_repo        = var.containers_git_repository      # Git repository for the containers
      git_repo_branch = var.build_branch                   # Branch to build
    })

    //temporarily set github-creds, fix later
    "github-creds.groovy" = templatefile("${path.module}/jenkins-init-groovy/github-creds.groovy", {
      credentials_id          = "github-credentials"             # Inject credentials ID
      credentials_description = "Github credentials for Jenkins" # Inject credentials description
      access_token            = var.jenkins_github_access_token  # Inject access token
      hook_secret_id          = "github-hook-secret"                  # Inject secret ID
      hook_secret_description = "Github hook secret for Jenkins"      # Inject secret description
      hook_secret             = var.jenkins_github_hook_secret   # Inject secret
      server_name             = "cifarm"
    })
  }
  jenkins_init_groovy_secret = {
    "github-creds.groovy" = templatefile("${path.module}/jenkins-init-groovy/github-creds.groovy", {
      credentials_id          = "github-credentials"             # Inject credentials ID
      credentials_description = "Github credentials for Jenkins" # Inject credentials description
      access_token            = var.jenkins_github_access_token  # Inject access token
      hook_secret_id          = "github-hook-secret"                  # Inject secret ID
      hook_secret_description = "Github hook secret for Jenkins"      # Inject secret description
      hook_secret             = var.jenkins_github_hook_secret   # Inject secret
      server_name             = "cifarm"
    })
  }
}

resource "kubernetes_config_map" "jenkins_init_groovy" {
  metadata {
    name      = local.jenkins_init_groovy_name
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  data = local.jenkins_init_groovy_cm
}

resource "kubernetes_secret" "jenkins_init_groovy" {
  metadata {
    name      = local.jenkins_init_groovy_name
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  data = local.jenkins_init_groovy_secret
}

# Helm release for the Jenkins
resource "helm_release" "jenkins" {
  name       = local.jenkins_name
  repository = var.bitnami_repository
  chart      = "jenkins"
  namespace  = kubernetes_namespace.jenkins.metadata[0].name

  values = [
    templatefile("${path.module}/manifests/jenkins-values.yaml", {
      user                     = var.jenkins_user,
      password                 = var.jenkins_password,
      node_group_label         = var.secondary_node_group_name,
      init_hook_scripts_cm     = kubernetes_config_map.jenkins_init_groovy.metadata[0].name,
      
      // wrong serviceName - create pull request to change into name
      // init_hook_scripts_secret = kubernetes_secret.jenkins_init_groovy.metadata[0].name
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

# regcred secret for pulling images from Dockerhub
resource "kubernetes_secret" "docker_credentials" {
  metadata {
    name = "docker-credentials"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = "${data.template_file.docker_credentials.rendered}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

# Template file for the 
data "template_file" "docker_credentials" {
  template = "${file("${path.module}/jsons/docker-credentials.json")}"
  vars = {
    docker_username           = "${var.docker_username}"
    docker_password           = "${var.docker_password}"
    docker_registry           = "${var.docker_registry}"
    docker_email              = "${var.docker_email}"
    auth                      = base64encode("${var.docker_username}:${var.docker_password}")
  }
}