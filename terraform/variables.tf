variable aws_account_id {
    type = string
    description = "The account ID for the AWS account."
}

variable image_url {
    type = string
    description = "The url for the container image."
}

variable "aws_region" {
  type = string
  description = "The AWS region in which to provision resources."
  default= "us-west-2"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.32.0.0/16"
}

variable "app_name" {
  description = "Application Name"
  type = string
  default = "ecs-pipelines"
}

variable "app_environment" {
  description = "environment"
  type = string
  default = "Production"
}

variable "public_subnets" {
  description = "List of public subnets"
  default     = ["10.32.100.0/24", "10.32.101.0/24"]
}

variable "private_subnets" {
  description = "List of private subnets"
  default     = ["10.32.0.0/24", "10.32.1.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["us-west-2a", "us-west-2b"]
}