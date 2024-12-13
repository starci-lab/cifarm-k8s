# Define an Internet Gateway (IGW) resource
resource "aws_internet_gateway" "igw" {
  
  # Associate the Internet Gateway with the specified VPC using the VPC ID
  vpc_id = aws_vpc.vpc.id
  
  # Tags to help identify and label the Internet Gateway
  tags = {
    # Name tag for the Internet Gateway, dynamically generated with the cluster name
    Name = "igw-${var.cluster_name}"
  }
}