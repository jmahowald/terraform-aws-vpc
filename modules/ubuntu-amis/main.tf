/**
 * Simple module that wraps a data aws_ami to give ubuntu on a per region basis.
 * Intended to work with the same conventions of ../amazon-amis and ../coreos-amis
 */
variable "aws_region" {}
variable "virtualization_type" {
  default = "hvm"
}
provider "aws" {
  region = "${var.aws_region}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["${var.virtualization_type}"]
  }

  owners = ["099720109477"] # Canonical
}

output "image_id" {
  value = "${data.aws_ami.ubuntu.image_id}"
}

output "image_user" {
  value = "ubuntu"
}
