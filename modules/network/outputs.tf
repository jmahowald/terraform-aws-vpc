
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
  # TODO rename to vpn_ip but that may
  # change conventions too much? for now
  value = "${aws_eip.vpn.public_ip}"
}

output "vpc_netmask" {
	value = "${var.vpc_base_ip}.0.0 255.255.0.0"
}



output "vpc_cidr" {
	value = "${var.vpc_base_ip}.0.0/16"
}


output "vpc_id" {
	value = "${aws_vpc.default.id}"
}
