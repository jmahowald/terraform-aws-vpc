
# Used to identify resources
variable "owner" {}
variable "environment_name" {}


# Addressing of subnets
variable "vpc_cidr" {
  default = "10.60.0.0/16"
}
variable "public_subnet_cidr" {
  default = "10.60.0.0/24"
}
variable "private_subnet_cidr" {
  default = "10.60.10.0/24"
}

# AWS specific variables
variable "aws_region" {
  default = "us-east-1"
}
output "aws_region" {
  value = "${var.aws_region}"
}

variable "aws_availability_zone" {
  default = "us-east-1a"
}
# If these variables are in a bucket, what is they key to use
output "bucket_key" {
  value = "${var.aws_region}/vpc/terraform.tfstate"
}


module "centos" {
  #TODO this should be core os?
  source = "../modules/centos-amis"
  version = "7"
  region = "${var.aws_region}"
}


module "network" {
	source = "../modules/network"
  key_name = "${var.key_name}"
  ssh_keypath = "${module.keys.key_path}"
  environment_name = "${var.environment_name}"
  image_user = "${module.centos.image_user}"
  ami = "${module.centos.ami_id}"
  vpc_cidr = "${var.vpc_cidr}"
  private_subnet_cidr = "${var.private_subnet_cidr}"
  public_subnet_cidr = "${var.public_subnet_cidr}"
	aws_availability_zone = "${var.aws_availability_zone}"
	aws_region = "${var.aws_region}"
  owner = "${var.owner}"
}


output "bastion_ip" {
  value = "${module.network.bastion_ip}"
}

output "bastion_user" {
  value = "${module.network.bastion_user}"
}

output "security_group_ids" {
  value = "${module.network.security_group}"
}

output "private_subnet_id" {
  value = "${module.network.private_subnet_id}"
}
