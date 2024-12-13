# Storage Class configuration for EBS volumes in EKS
# This resource defines a custom storage class for persistent volumes in Kubernetes.
# It uses AWS Elastic Block Store (EBS) as the storage backend for the volumes.

resource "kubernetes_storage_class" "storageclass_gp2" {
  
  # Metadata for the storage class resource
  # Defines the name of the storage class and includes annotations for Kubernetes.
  metadata {
    name = "gp2-encrypted"  # The name of the storage class. This name will be used when requesting persistent volumes.
    
    # Annotations to mark this storage class as the default for the cluster.
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"  # This marks the storage class as the default one for PVs.
    }
  }

  # The storage provisioner specifies the driver to use for provisioning volumes.
  storage_provisioner    = "ebs.csi.aws.com"  # Specifies the AWS EBS CSI driver for creating and managing EBS volumes.

  # Reclaim policy defines what happens when the persistent volume is released (e.g., when it's deleted).
  reclaim_policy         = "Delete"  # This means the EBS volume will be deleted when the PersistentVolumeClaim (PVC) is deleted.

  # Allow volume expansion allows the storage volume size to be increased after creation.
  allow_volume_expansion = true  # Enables resizing of volumes after they have been created.

  # Volume binding mode controls when a volume is bound to a PVC. "WaitForFirstConsumer" delays the binding until a pod using the PVC is scheduled.
  volume_binding_mode    = "WaitForFirstConsumer"  # This delays the volume binding until the first consumer (pod) is scheduled.

  # Parameters that define the specifics of the storage provisioned
  parameters = {
    type      = "gp2"        # Specifies the type of EBS volume. 'gp2' is the General Purpose SSD type.
    encrypted = "true"       # Ensures that the EBS volume is encrypted.
  }
}