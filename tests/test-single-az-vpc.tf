variable "aws_region" {
  default = "us-west-2"
}
variable "aws_availability_zone" {
  default = "us-west-2b"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "environment_name" {
  default = "testing"
}
variable "owner" {
  defualt = "Test User"
}



# Addressing of subnets
variable "vpc_cidr" {
  default = "192.168.0.0/16"
}
variable "public_subnet_cidrs" {
  default = ["192.168.1.0/24"]
}
variable "private_subnet_cidrs" {
  default = ["192.168.2.0/24"]
}

variable "key_name" {
  default = "testingkey"
}


output "bastion_ips" {
  value = "${module.vpc.bastion_ips}"
}
output "bastion_user" {
  value = "${module.vpc.bastion_user}"
}
output "image_user" {
  value = "${module.centos.image_user}"
}
output "test_ip" {
  value = "${aws_instance.test.private_ip}"
}
output "key_file" {
  value = "${module.keys.key_path}"
}


module "vpc" {
  aws_region = "${var.aws_region}"
  aws_availability_zone = "${var.aws_availability_zone}"
  source = "../modules/network"
  key_name = "testingdeploy"
  key_dir = ".keys/"
  environment_name = "${var.environment_name}"
  owner = "${var.owner}"
  vpc_cidr = "${var.vpc_cidr}"
  count=1
  public_subnet_cidrs = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
}

module "security_groups" {
  environment_name = "${var.environment_name}"
  source = "../modules/security_groups/all_vpc"
}

module "keys" {
  source = "../modules/keys"
  key_dir = ".keys/"
  key_name = "${var.key_name}"
}

output vpc_id {
  value = "${module.vpc.vpc_id}"
}

module "centos" {
  #TODO this should go into separate module
  source = "../modules/centos-amis"
  version = "7"
  region = "${var.aws_region}"
}

resource "aws_instance" "test" {
    availability_zone = "${var.aws_availability_zone}"
    ami = "${module.centos.ami_id}"
    subnet_id = "${element(module.vpc.private_subnet_ids, 0)}"
    instance_type = "${var.instance_type}"
    key_name = "${module.keys.key_name}"
    vpc_security_group_ids = [ "${module.security_groups.security_group_ids}" ]
    tags {
      Name = "testing-instance"
      Owner = "${var.owner}"
      Environment = "testing"
    }

    connection {
        user =  "${module.centos.image_user}"
        agent = false
        private_key = "${file(module.keys.key_path)}"
        bastion_host = "${module.vpc.bastion_ips[0]}"
        bastion_user = "${module.vpc.bastion_user}"
    }

    provisioner "remote-exec" {
        inline =  [
            "echo 'hello world' > test.txt"
        ]
    }
}
