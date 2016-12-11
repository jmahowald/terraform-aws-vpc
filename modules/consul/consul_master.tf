variable "key_name" {}
variable "ssh_keypath"{}
variable "ami" {}
# TODO this should be multiple and we should be using a map to spread out the
# masters
/*variable "aws_availability_zone_primary" {}*/
variable "subnet_ids" {
  type = "list"
}

variable tags {
  type = "map"
  default = {}
}

variable "security_group_ids"{
  /*type = "list"*/
}
variable "consul_install_dir" {
  default="/var/consul"
}
variable "server_user" {
  default = "core"
}

/**
 * Note that as of now, we can't actually override
 * this value in the module, so if you want to change the
 * number you must modify it in this file
 */
variable "count" {
  default ="3"
}


variable "instance_type" {
	default = "t2.micro"
}

variable "consul_local_config" {
  default = "{\"skip_leave_on_interrupt\": true}" 
}

data "template_file" "start_consul_sh" {
  template = "${file("${path.module}/consul_server.sh.tpl")}"
  count = "${var.count}"
  vars {
    num_servers = "${var.count}"
    # Script should have both it's own address
    address = "${element(aws_instance.consul_server.*.private_ip, count.index)}"
    # as well as a root node to run against
    root_address = "${element(aws_instance.consul_server.*.private_ip, 0)}"
    index = "${count.index}"
    consul_local_config = "${var.consul_local_config}"
  }
}

resource "null_resource" "start_script_provision" {
  count = "${var.count}"

    # Changes to any instance of the cluster requires re-provisioning
    # This is probably wrong and maybe I should just use my own host
   triggers {
     cluster_instance_ids = "${join(",", aws_instance.consul_server.*.id)}"
   }
   connection {
     host = "${element(aws_instance.consul_server.*.private_ip, count.index)}"
     user =  "core"
     private_key = "${file(var.ssh_keypath)}"
   }
   provisioner "remote-exec" {
     inline = [
      "sudo mkdir -p ${var.consul_install_dir}",
      "cat << 'CONSUL_START_SCRIPT' > ${var.consul_install_dir}/consul_start.sh",
      "${element(data.template_file.start_consul_sh.*.rendered, count.index)}",
      "CONSUL_START_SCRIPT",
      "sudo chmod 755 ${var.consul_install_dir}/consul_start.sh",
      "${var.consul_install_dir}/consul_start.sh",
     ]
   }
}


resource "aws_security_group_rule" "consul_http" {
  type = "ingress"
  security_group_id = "${element(split(",",var.security_group_ids),0)}"
  from_port = 8500
  to_port   = 8500
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}



data "aws_ami" "coreos" {
  most_recent = true
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }
}

# We have a bootstrap
resource "aws_instance" "consul_server" {
    // name="consul-server-${count.index}"
    ami = "${data.aws_ami.coreos.image_id}"
    subnet_id = "${element(var.subnet_ids, count.index % length(var.subnet_ids))}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    # TODO
    # Have had lots of issues with this as a variable
    count = "${var.count}"
    vpc_security_group_ids = ["${split(",",var.security_group_ids)}"]
    tags = "${merge(map("Name","consul-${count.index}"),var.tags)}"
    connection {
        user =  "core"
        private_key = "${file(var.ssh_keypath)}"
    }
    provisioner "remote-exec" {
        inline =  [
            "docker pull consul",
            "sudo mkdir -p ${var.consul_install_dir}",
            "sudo chown core ${var.consul_install_dir}"
        ]
    }
}


output  "consul_servers_ips" {
  value = ["${aws_instance.consul_server.*.private_ip}"]
}
