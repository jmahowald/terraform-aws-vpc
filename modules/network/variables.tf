variable "ssh_keypath" {}
variable "key_name" {}
variable "environment_name" {}

variable "owner" {}

variable "ami" {}
variable "image_user" {}
variable "instance_type" {
  default = "t2.micro"
}


variable "aws_region" {}
