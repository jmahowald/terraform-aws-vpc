/* NAT/VPN server */


resource "aws_instance" "vpn" {

  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.public.id}"
  #This should release all the resources, like the associated EBS volume
  instance_initiated_shutdown_behavior = "terminate"
  root_block_device {
    delete_on_termination = true
  }

  # TODO allow for multiple security security_groups
  # but since they need to be joined/split for parameters
  # right now, a single security group will suffice
  vpc_security_group_ids = ["${aws_security_group.default.id}", "${aws_security_group.nat.id}"]
  key_name = "${var.key_name}"

  #TODO look into why the heck I think I needed this flag
  source_dest_check = false
   tags = {
    Name = "vpn-nat"
    EnvironmentName = "${var.environment_name}"
    Owner = "${var.owner}"
  }
  connection {
    user =  "${var.image_user}"
    #    https://github.com/hashicorp/terraform/issues/2563
    #    Shouldn't need to specify this but issue above
    agent = "false"
    key_file = "${var.ssh_keypath}"
  }


  provisioner "remote-exec" {
    inline = [
    # I have no idea why these two are what enable NAT
    # usage, but it works.  The question is will it survive a reboot .
    "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
    "echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/forwarding > /dev/null",
    ]
  }
}


resource "aws_eip" "vpn" {
  vpc = true
  instance = "${aws_instance.vpn.id}"
  # EIP associations have issues, so we need to setup here
  # HT: https://github.com/hashicorp/terraform/issues/6758#issuecomment-220229768
  /*associate_with_private_ip = "${aws_instance.vpn.private_ip}"*/
  instance = "${aws_instance.vpn.id}"

  lifecycle {
    create_before_destroy = "true"
  }

}



output "bastion_user" {
  value = "${var.image_user}"
}
