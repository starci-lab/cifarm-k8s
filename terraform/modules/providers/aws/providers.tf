provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# AWS Caller Identity
data "aws_caller_identity" "current" {}

# AWS Availability Zones
data "aws_availability_zones" "available" {}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
    cluster_name = "${var.cluster_base_name}-${random_string.suffix.result}"
    primary_node_group_name = "${var.primary_node_base_group_name}-${random_string.suffix.result}"
    secondary_node_group_name = "${var.secondary_node_base_group_name}-${random_string.suffix.result}"
}