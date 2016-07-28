variable "aws_availability_zone" {}
variable "vpc_id" {}
variable "private_subnet_cidr" {}
variable "public_subnet_cidr" {}

output "bastion_ip" {
  # TODO rename to jump_ip but that may
  # change conventions too much? for now
  value = "${aws_eip.jump.public_ip}"
}

output "private_subnet_id" {
	value = "${aws_subnet.private.id}"
}

output "public_subnet_id" {
	value = "${aws_subnet.public.id}"
}
