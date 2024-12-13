resource "aws_eip" "eip" {
  # Specify that this Elastic IP (EIP) is associated with the VPC
  domain = "vpc"

  # Ensure that the Internet Gateway is created before associating the EIP
  depends_on = [aws_internet_gateway.igw]

  # Tags to help identify and label the Elastic IP
  tags = {
    # Name tag dynamically set using the cluster name
    Name = "eip-${var.cluster_name}"
  }
}