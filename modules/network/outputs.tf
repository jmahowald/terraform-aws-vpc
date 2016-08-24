
output "vpc_id" {
  value = "${aws_vpc.default.id}"
}
output "bastion_user" {
  value = "${var.image_user}"
}
// NOTE.  I swear when I tested, if I used the name of
// private_security_group_id I got the value for the public instance
output "private_sg_id" {
  value = "${aws_security_group.private.id}"
}
output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}


output "bastion_ips" {
  # TODO rename to jump_ip but that may
  # change conventions too much? for now
  value = ["${aws_eip.jump.*.public_ip}"]
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}
output "private_route_table_ids" {
    value = ["${aws_route_table.private.*.id}"]
}

output "public_sg_id" {
  value = "${aws_security_group.public.id}"
}
output "availabity_zones" {
  //Note that this is not necessarily the same as the avialability zones
  //used.  That is much harder to calculate (though I believe it can be done
  //with the null_resource trigger trick
  value = ["${data.aws_availability_zones.available.names}"]
}
