variable "ssh_keypath" {}
variable "key_name" {}
variable "environment_name" {}

variable "aws_region" {
	default = "us-east-1"
}
variable "aws_availability_zone" {
	default = "us-east-1b"
}



variable "vpc_base_ip" {
	default = "10.72"
}


variable "ami" {}
variable "image_user" {}
variable "instance_type" {
  default = "t2.micro"
}

variable "owner" {}
