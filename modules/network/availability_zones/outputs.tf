

output "bastion_ips" {
  # TODO rename to jump_ip but that may
  # change conventions too much? for now
#  value = "[${aws_eip.jump.*.public_ip}]"
  value = []
}


output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "bastion_user" {
  value = "${var.image_user}"
}
