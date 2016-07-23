


variable "docker_preinstalled" {
  default = "false"
}

variable "host_address" {}
variable "host_user" {}
variable "ssh_keypath" {}
variable "vpn_cidr" {}
variable "remote_script_dir" {
  default = "/usr/local/bin"
}

variable "vpn_image" {
  default = "gosuri/openvpn"
}

# This module will output scripts.  Where should they go
variable "script_folder" {
  default = "bin"
}

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
    private_key = "${var.ssh_keypath}"
  }

  provisioner "remote-exec" {
    inline=[

      # TODO make this optional based of
      # docker preinstalled variable
       "curl -sSL https://get.docker.com/ | sudo sh",
      # Well this pretty much only works on centos7
      "sudo systemctl enable docker.service",
      "sudo service docker start",

      # TODO make this always be running
      "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
      "sudo docker run --volumes-from ovpn-data --rm ${var.vpn_image} ovpn_genconfig -p ${var.vpn_cidr} -u udp://${var.host_address}",


      "cat << 'VPN_START_SCRIPT' > /tmp/vpn_start.sh",
      "${template_file.ovpn_start.rendered}",
      "VPN_START_SCRIPT",
      "sudo mv /tmp/vpn_start.sh ${var.remote_script_dir}/vpn_start.sh",
      "sudo chmod 755 ${var.remote_script_dir}/vpn_start.sh",
      "sudo ${var.remote_script_dir}/vpn_start.sh",



]
  }
  provisioner "local-exec" {
    command = "echo not really creating the vpn yet"
  }
//  depen ["template_file.ovpn_init"]
}

/*

"sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vpc_base_ip}.0.0/16 -u udp://${aws_eip.nat.public_ip}",
"sudo iptables-save",*/
#do"sudo docker run --volumes-from ovpn-data -e OVPN_PORT=8080 --rm gosuri/openvpn ovpn_genconfig -p 10.72.0.0/16 -u udp://54.183.79.121  "
/*
resource "template_file" "mytest" {
  template = "Hello ${user}"
  vars {
    user = "foo"
  }
}*/


resource "template_file" "ovpn_start" {
  template ="${file("${path.module}/vpn_start.sh")}"
}

/**
 *  This section contains templates that will be used to render
 *  scripts locally.  There is a good chance this can be done more
 *  cleanly, but . . . (it works/lazy)
 */
resource "template_file" "ovpn_init" {
  template = "${file("${path.module}/ovpn-init.tpl")}"
  vars {
    host = "${var.host_address}"
    key_path = "${var.ssh_keypath}"
    user = "${var.host_user}"
    init_command = "sudo docker run --volumes-from ovpn-data --rm -it ${var.vpn_image} ovpn_initpki"
  }
   provisioner "local-exec" {
    command = <<EOC_TERRAFORM
mkdir -p ${var.script_folder}

(
cat <<'EOP_SHELL'
${self.rendered}
EOP_SHELL
) > ${var.script_folder}/ovpn-init
chmod 755 ${var.script_folder}/ovpn-init

EOC_TERRAFORM
  }
}

resource "template_file" "ovpn-new-client" {
  template = "${file("${path.module}/ovpn-new-client.tpl")}"
  vars {
    host = "${var.host_address}"
    key_path = "${var.ssh_keypath}"
    user = "${var.host_user}"
  }
   provisioner "local-exec" {
    command = <<EOC_TERRAFORM
mkdir -p ${var.script_folder}

(
cat <<'EOP_SHELL'
${self.rendered}
EOP_SHELL
) > ${var.script_folder}/ovpn-new-client
chmod 755 ${var.script_folder}/ovpn-new-client
EOC_TERRAFORM
  }
}


resource "template_file" "ovpn-get-client-config" {
  template = "${file("${path.module}/ovpn-get-client-config.tpl")}"
  vars {
    host = "${var.host_address}"
    key_path = "${var.ssh_keypath}"
    user = "${var.host_user}"
    vpc_netmask = "${cidrhost("${var.vpn_cidr}", 1)} ${cidrnetmask("${var.vpn_cidr}")}"
  }
   provisioner "local-exec" {
    command = <<EOC_TERRAFORM
mkdir -p ${var.script_folder}

(
cat <<'EOP_SHELL'
${self.rendered}
EOP_SHELL
) > ${var.script_folder}/ovpn-get-client-config
chmod 755 ${var.script_folder}/ovpn-get-client-config
EOC_TERRAFORM
  }
}



/*

resource "template_file"  "ovpn_start" {
  template = "${file("${path.module}/ovpn-init.tpl")}"
  vars {
    host = "${var.host_address}"
    key_path = "${var.ssh_keypath}"
    user = "${var.host_user}"
    init_command = "sudo docker run --volumes-from ovpn-data --rm -it ${var.vpn_image} ovpn_initpki"
  }

}*/
