# Template file for the 
data "template_file" "docker_credentials" {
  template = file("${path.module}/credentials/docker-credentials.json")
  vars = {
    docker_username = "${var.docker_username}"
    docker_password = "${var.docker_password}"
    docker_registry = "${var.docker_registry}"
    docker_email    = "${var.docker_email}"
    auth            = base64encode("${var.docker_username}:${var.docker_password}")
  }
}

# regcred secret for pulling images from Dockerhub
resource "kubernetes_secret" "docker_credentials" {
  metadata {
    name      = "docker-credentials"
    namespace =  var.system_namespace
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
