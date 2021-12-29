// VPC
data "aws_vpc" "vpc" {
  id = var.vpc
}

// DNS Zone
data "aws_route53_zone" "zone" {
  name         = var.zone
  private_zone = false
}

// Subnet
data "aws_subnet" "subnet" {
  filter {
    name   = "tag:Name"
    values = [var.subnet]
  }
}

// Security group
data "aws_security_group" "security_group" {
  filter {
    name   = "tag:Name"
    values = [var.security_group]
  }
}
