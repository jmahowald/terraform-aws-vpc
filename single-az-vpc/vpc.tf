
variable "owner" {}
variable "environment_name" {}
variable "vpc_base_ip" {
  default = "10.60"
}
variable "aws_region" {
  default = "us-east-1"
}

variable "aws_availability_zone" {
  default = "us-east-1a"
}

variable "key_name" {
  default = "deploykey"
}

variable "key_dir" {
  default = "~/.keys"
}
provider "aws" {
  region = "${var.aws_region}"
}

module "keys" {
  source = "../modules/keys"
  key_name="${var.key_name}"
  key_dir="${var.key_dir}"
}

module "remote_state" {
  source = "../modules/terraform_remote_s3bucket"
  bucket_name = "vpc-state"
}
module "centos" {
  #TODO this should be core os?
  source = "../modules/centos-amis"
  version = "7"
  region = "${var.aws_region}"
}

output "bucket" {
  value = "${module.remote_state.name}"
}

output "bastion_ip" {
  value = "${module.network.bastion_ip}"
}

output "security_group_ids" {
  value = "${module.network.security_group}"
}

output "private_subnet_id" {
  value = "${module.network.private_subnet_id}"
}


module "network" {
	source = "../modules/network"
  key_name = "${var.key_name}"
  ssh_keypath = "${module.keys.key_path}"
  environment_name = "${var.environment_name}"
  image_user = "${module.centos.image_user}"
  ami = "${module.centos.ami_id}"
  vpc_base_ip = "${var.vpc_base_ip}"
	aws_availability_zone = "${var.aws_availability_zone}"
	aws_region = "${var.aws_region}"
  owner = "${var.owner}"
}
