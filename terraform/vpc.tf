resource "aws_vpc" "aws-vpc" {
    cidr_block = var.cidr
    enable_dns_hostnames = true
    enable_dns_support = true
}