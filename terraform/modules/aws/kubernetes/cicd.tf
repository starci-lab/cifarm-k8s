# Namespace for cicd resources
resource "kubernetes_namespace" "cicd" {
    metadata {
        name = "cicd"
    }
}

# Helm release for the Jenkins
resource "helm_release" "jenkins" {
    name       = "jenkins"
    repository = var.bitnami_repository
    chart      = "jenkins"
    namespace  = kubernetes_namespace.cicd.metadata[0].name

    values = [
        templatefile("${path.module}/manifests/jenkins-values.yaml", {
            user = var.jenkins_user,
            password = var.jenkins_password,
            node_group_label = var.secondary_node_group_name
        })
    ]
}
