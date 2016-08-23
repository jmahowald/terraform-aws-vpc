variable "count" {
  default = 1
}
variable "vpc_id" {}
variable "aws_region"{}
variable "internet_gateway_id"{}
variable "owner" {
  # See https://github.com/hashicorp/terraform/issues/8146
  # for why this is set
}
variable "environment"{}
variable "key_name"{}

variable "public_subnet_cidrs" {
  type="list"
}
variable "jumphost_security_group_ids" {
  type="list"
}

data "aws_availability_zones" "available" {}


output "bastion_ips" {
  # TODO rename to jump_ip but that may
  # change conventions too much? for now
#  value = "[${aws_eip.jump.*.public_ip}]"
  value = []
}


output "public_subnet_ids" {
  value = "[${aws_subnet.public.*.id}]"
}
