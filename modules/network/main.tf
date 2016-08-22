variable "ssh_keypath" {}
variable "key_name" {}
variable "environment" {}
variable "owner" {
  default = "Unknown"
  # See https://github.com/hashicorp/terraform/issues/8146
  # for why this is set
}
variable "ami" {}
variable "image_user" {}
variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
	type = "list"
}
variable "private_subnet_cidrs" {
	type = "list"
}

variable "count" {
  default = "1"
}
variable "aws_region" {}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "bastion_user" {
  value = "${module.azs.bastion_user}"
}
output "private_subnet_ids" {
  value= "${module.azs.private_subnet_ids}"
}
output "bastion_ips" {
  vaue = "${module.azs.bastion_ips}"
}
