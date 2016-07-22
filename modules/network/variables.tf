variable "ssh_keypath" {}
variable "key_name" {}
variable "environment_name" {}

variable "aws_region" {
	default = "us-east-1"
}
variable "aws_availability_zone" {
	default = "us-east-1b"
}


variable "vpc_cidr" {}
variable "private_subnet_cidr" {}
variable "public_subnet_cidr" {}

variable "ami" {}
variable "image_user" {}
variable "instance_type" {
  default = "t2.micro"
}

variable "owner" {}
