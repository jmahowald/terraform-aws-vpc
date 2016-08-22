/* NAT/jump server */


variable "ami" {}
variable "image_user" {}
variable "instance_type" {
  default = "t2.micro"
}

variable "delete_jump_host_volume_on_termination" {
  default = true
}

variable "ssh_keypath" {}
/**
//TODO we could easily make this not be in each AZ by having a separate count
resource "aws_instance" "jump" {
  ami = "${var.ami}"
  count = "${var.count}"
  instance_type = "${var.instance_type}"
  subnet_id = "${element("${aws_subnet.public.*.id}", count.index)}"
  #This should release all the resources, like the associated EBS volume
  instance_initiated_shutdown_behavior = "terminate"

  # Lazy Hack.  Users may want to add a VPN (but not everyone)
  # For those that do however, it's nice to keep the volume around
  # so we wouldn't need to recut vpn certs
  root_block_device {
    delete_on_termination = "${var.delete_jump_host_volume_on_termination}"
  }

  # TODO allow for multiple security security_groups
  # but since they need to be joined/split for parameters
  # right now, a single security group will suffice
  vpc_security_group_ids = ["${split(",", "${var.jumphost_security_group_ids}")}"]
  key_name = "${var.key_name}"
  #TODO look into why the heck I think I needed this flag
  source_dest_check = false
   tags = {
    Name = "jump-nat - ${count.index}"
    EnvironmentName = "${var.environment}"
    Owner = "${var.owner}"
  }
  connection {
    user =  "${var.image_user}"
    #    https://github.com/hashicorp/terraform/issues/2563
    #    Shouldn't need to specify this but issue above
    agent = "false"
    key_file = "${var.ssh_keypath}"
  }


  //Should probably look at using NAT gateway, but is more expensive
  //and we still want jump hosts in each AZ (at least I think we do)
  provisioner "remote-exec" {
    inline = [
    # I have no idea why these two are what enable NAT
    # usage, but it works.  The question is will it survive a reboot .
    "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
    "echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/forwarding > /dev/null",
    ]
  }
}


resource "aws_eip" "jump" {
  vpc = true
  count = "${var.count}"
  instance = "${element("${aws_instance.jump.*.id}", "${count.index}")}"
  # EIP associations have issues, so we need to setup here
  # HT: https://github.com/hashicorp/terraform/issues/6758#issuecomment-220229768
  # associate_with_private_ip = "${aws_instance.jump.private_ip}"
  lifecycle {
    create_before_destroy = "true"
  }
}

output "bastion_ips" {
  value = "[${aws_eip.jump.*.ip}]"
}
**/


output "bastion_user" {
  value = "${var.image_user}"
}
