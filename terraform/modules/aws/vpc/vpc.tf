# Define a VPC (Virtual Private Cloud) resource
resource "aws_vpc" "vpc" {

  # CIDR block defines the IP address range for the VPC
  # The VPC will have a range of IPs from 10.0.0.0 to 10.0.255.255
  cidr_block = "10.0.0.0/16"
  
  # Tags to help identify and label the VPC
  tags = {
    # Name tag for the VPC, dynamically generated with the cluster name
    Name = "vpc-${var.cluster_name}"

    # Tag to indicate the cluster the VPC is associated with, specific for Kubernetes
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}