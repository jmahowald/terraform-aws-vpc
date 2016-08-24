variable "count" {
  default = 1
}
variable "vpc_id" {}
variable "aws_region"{}
variable "internet_gateway_id"{}
variable "owner" {
  default = "Unknown"
  # See https://github.com/hashicorp/terraform/issues/8146
  # for why this is set
}
variable "environment"{}
variable "key_name"{}

variable "public_subnet_cidrs" {
}
variable "jumphost_security_group_ids" {
}

variable "aws_availability_zones" {}
variable "private_subnet_cidrs" {
}
