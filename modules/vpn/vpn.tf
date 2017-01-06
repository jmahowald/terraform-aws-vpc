


variable "host_address" {}
variable "host_user" {}
variable "ssh_keypath"{}
variable "vpn_cidr" {}


variable "ca_common_name" {
  default = "myorg"
}

variable "docker_preinstalled" {
  default = "1"
  description = "Set to empty string to hve docker be installed"
}

variable "remote_script_dir" {
  default = "/var/openvpn"
}
variable "vpn_image" {
  default = "kylemanna/openvpn"
}
# This module will output scripts.  Where should they go
variable "script_folder" {
  default = "bin"
}

variable "nopassword" {
  default = ""
  description = "Set this to anything if you want to disable passwords for the ca cert for openvpn"
}


variable "security_group_id" {}
# Script to be put on remote end that will
# start up the openvpn server (and ideally make it auto
# restart on reboot)
/*resource "template" "openvpn_start_script" {
}

# Script run locally that will initialize
# the vpn server
resource "template" "openvpn_init_script" {
}*/

/*provider "aws"{}*/
resource "null_resource" "start_openvpn" {
  # Rerun if any of these change
  triggers {
    host_address = "${var.host_address}"
    host_user = "${var.host_user}"
    host_key = "${var.ssh_keypath}"
  }
  connection {
    user = "${var.host_user}"
    host = "${var.host_address}"
    private_key = "${file(var.ssh_keypath)}"
  }

  provisioner "remote-exec" {
    inline=[
      "sudo mkdir -p ${var.remote_script_dir}",
      "sudo chown ${var.host_user} ${var.remote_script_dir}",
      "cat << 'VPN_START_SCRIPT' >  ${var.remote_script_dir}/vpn_start.sh",
      "${data.template_file.ovpn_start.rendered}",
      "VPN_START_SCRIPT",
      "sudo chmod 755 ${var.remote_script_dir}/vpn_start.sh",
      "sudo  DOCKER_INSTALLED=${var.docker_preinstalled} ${var.remote_script_dir}/vpn_start.sh ",      
]
  }

   provisioner "local-exec" {
    command = <<EOC_TERRAFORM
mkdir -p ${var.script_folder}

(
cat <<'EOP_SHELL'
${data.template_file.ovpn-new-client.rendered}
EOP_SHELL
) > ${var.script_folder}/ovpn-new-client
chmod 755 ${var.script_folder}/ovpn-new-client
EOC_TERRAFORM
  }


 provisioner "local-exec" {
    command = <<EOC_TERRAFORM
mkdir -p ${var.script_folder}

(
cat <<'EOP_SHELL'
${data.template_file.ovpn_init.rendered}
EOP_SHELL
) > ${var.script_folder}/ovpn-init
chmod 755 ${var.script_folder}/ovpn-init
EOC_TERRAFORM
  }

}




data "template_file" "ovpn_start" {
  template ="${file("${path.module}/vpn_start.sh")}"
  vars {
    vpn_image = "${var.vpn_image}"
    vpn_cidr = "${var.vpn_cidr}"
    host_address = "${var.host_address}"
  }
}

/**
 *  This section contains templates that will be used to render
 *  scripts locally.  There is a good chance this can be done more
 *  cleanly, but . . . (it works/lazy)
 */
data "template_file" "ovpn_init" {
  template = "${file("${path.module}/ovpn-init.tpl")}"
  vars {
    vpn_image = "${var.vpn_image}"
    key_path = "${var.ssh_keypath}"
    user = "${var.host_user}"
    ca_common_name = "${var.ca_common_name}"
    host_address = "${var.host_address}"

  }
  
}


resource "aws_security_group_rule" "vpn_in" {
  type = "ingress"
  security_group_id = "${var.security_group_id}"
  from_port = 1194
  to_port   = 1194
  protocol  = "udp"
  cidr_blocks = ["0.0.0.0/0"]
}


data "template_file" "ovpn-new-client" {
  template = "${file("${path.module}/ovpn-new-client.tpl")}"
  vars {
    host = "${var.host_address}"
    key_path = "${var.ssh_keypath}"
    user = "${var.host_user}"
    vpc_netmask = "${cidrhost("${var.vpn_cidr}", 1)} ${cidrnetmask("${var.vpn_cidr}")}"
    vpn_image="${var.vpn_image}"
  }
  
}


