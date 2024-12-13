# Define an NAT Gateway resource
resource "aws_nat_gateway" "nat" {
  # The allocation ID of the Elastic IP (EIP) that will be associated with the NAT Gateway
  allocation_id = aws_eip.eip.id

  # The subnet where the NAT Gateway will be created. It must be a public subnet.
  subnet_id = aws_subnet.public_subnets["public-1"].id  # Ensure this references a Public Subnet

  # Tags to help identify and label the NAT Gateway
  tags = {
    # Name tag dynamically set using the cluster name
    Name = "nat-${var.cluster_name}"
  }
}