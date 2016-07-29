// Used for mapping regions to availability zones.  Note that some regions only have
// two
module "az" {
  source = "github.com/terraform-community-modules/tf_aws_availability_zones_cfn"
  region = "${var.aws_region}"
}
variable "count" {
  default = 2
}
variable "vpc_id" {}
variable "aws_region"{}
variable "private_subnet_cidrs" {}
variable "public_subnet_cidrs" {}
variable "jumphost_security_group_ids" {}

output availability_zones {
  value = "${module.az.list_all}"
}

output "bastion_ips" {
  # TODO rename to jump_ip but that may
  # change conventions too much? for now
  value = "${join(",", aws_eip.jump.*.public_ip)}"
}

//TODO change this to be correct,  
output "private_subnet_ids" {
	value = "${join(",", aws_subnet.public.*.id)}"
}

output "public_subnet_ids" {
  value = "${join(",", aws_subnet.public.*.id)}"
}
