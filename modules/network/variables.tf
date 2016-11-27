
variable "environment" {}
variable "owner" {}

/** Network information **/
variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
	type = "list"
}
variable "private_subnet_cidrs" {
	type = "list"
}
variable "availability_zone_count" {
  default = "1"
}
variable "bastion_server_count" {
  default = "1"
}

variable "aws_region" {}




/** For creating the bastion host **/
variable "ami" {}
variable "image_user" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "delete_jump_host_volume_on_termination" {
  default = true
}
variable "key_name" {}
variable "ssh_keypath" {}
//TODO we could easily make this not be in each AZ by having a separate count
