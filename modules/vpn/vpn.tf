


variable "docker_preinstalled" {
  default = "false"
}

variable "host_address" {}
variable "host_user" {}
variable "host_key" {}

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
    host_user = "${var.host_address}"
    host_key = "${var.host_address}"
  }
  provisioner "local-exec" {
    command = "echo not really creating the vpn yet"
  }
}
