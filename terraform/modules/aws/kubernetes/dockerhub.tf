# regcred secret for pulling images from Dockerhub
resource "kubernetes_secret" "docker_credentials" {
  metadata {
    name      = "docker-credentials"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  data = {
    ".dockerconfigjson" = "${data.template_file.docker_credentials.rendered}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

locals {
  set_pull_secrets = [
    {
      name  = "global.imagePullSecrets[0].name"
      value = kubernetes_secret.docker_credentials.metadata[0].name
    }
  ]
}
