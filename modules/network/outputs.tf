
output "private_subnet_id" {
	value = "${aws_subnet.private.id}"
}

output "vpc_id" {
	value = "${aws_vpc.default.id}"
}

output "public_subnet_id" {
	value = "${aws_subnet.public.id}"
}

output "nat_security_group" {
	value = "${aws_security_group.nat.id}"
}

output "security_group" {
	value = "${aws_security_group.default.id}"
}

output "web_security_group" {
	value = "${aws_security_group.web.id}"
}

output "bastion_ip" {
  # TODO rename to jump_ip but that may
  # change conventions too much? for now
  value = "${aws_eip.jump.public_ip}"
}

output "vpc_netmask" {
	value = "${cidrmask(var.vpc_cidr)}"
}



output "vpc_cidr" {
	value = "${var.vpc_cidr}"
}


output "vpc_id" {
	value = "${aws_vpc.default.id}"
}
