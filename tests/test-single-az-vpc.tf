variable "aws_region" {
  default = "us-west-2"
}
variable "aws_availability_zone" {
  default = "us-west-2b"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "environment" {
  default = "testing"
}
variable "owner" {
  default = "Test User"
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


output "bastion_ip" {
  value = "${module.vpc.bastion_ips}"
}

output "bastion_ip_1" {
  value = "${element(module.vpc.bastion_ips, 0)}"
}
output "bastion_user" {
  value = "${module.vpc.bastion_user}"
}
output "image_user" {
  value = "${module.centos.image_user}"
}
output "key_file" {
  value = "${module.keys.key_path}"
}


module "vpc" {
  aws_region = "${var.aws_region}"
  source = "../modules/network"
  key_name = "testingdeploy"
  ssh_keypath = "${module.keys.key_path}"
  environment = "${var.environment}"
  owner = "${var.owner}"
  vpc_cidr = "${var.vpc_cidr}"
  availability_zone_count=1
  public_subnet_cidrs = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  environment = "${var.environment}"
  ami = "${module.centos.ami_id}"
  image_user ="${module.centos.image_user}"
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
    availability_zone = "${element(module.vpc.availabity_zones,count.index)}"
    ami = "${module.centos.ami_id}"
    subnet_id = "${element(module.vpc.private_subnet_ids, count.index)}"
    instance_type = "${var.instance_type}"
    key_name = "${module.keys.key_name}"
    count=1
    vpc_security_group_ids = [ "${module.vpc.private_sg_id}" ]
    tags {
      Name = "testing-instance-${count.index}"
      Owner = "${var.owner}"
      Environment = "${var.environment}"
    }
    connection {
        user =  "${module.centos.image_user}"
        agent = false
        private_key = "${file(module.keys.key_path)}"
        bastion_host = "${element(module.vpc.bastion_ips,count.index)}"
        bastion_user = "${module.vpc.bastion_user}"
    }

    provisioner "remote-exec" {
        inline =  [
            "echo 'hello world' > test.txt"
        ]
    }
}
output "test_ip" {
  value = "${aws_instance.test.private_ip}"
}
