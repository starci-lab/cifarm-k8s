resource "kubernetes_storage_class" "ebs_storage_class" {
    metadata {
      name = "ebs_storage_class"
    }
    storage_provisioner = "kubernetes.io/aws-ebs"

    parameters = {
        type = "gp2"
        encrypted: "true"
    }   

    volume_binding_mode = "WaitForFirstConsumer"

    reclaim_policy = "Retain"

    allowed_topologies {
        match_label_expressions {
            key = "failure-domain.beta.kubernetes.io/zone"
            values = [module.provider.ebs_volume_az]
        }
    }
}