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



# Addressing of subnets
variable "vpc_cidr" {
  default = "192.168.0.0/16"
}
variable "public_subnet_cidr" {
  default = "192.168.1.0/24"
}
variable "private_subnet_cidr" {
  default = "192.168.2.0/24"
}


output "bastion_ip" {
  value = "${module.vpc.bastion_ip}"
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
  value = "${module.vpc.key_file}"
}


module "vpc" {
  aws_region = "${var.aws_region}"
  aws_availability_zone = "${var.aws_availability_zone}"
  source = "../single-az-vpc"
  key_name = "testingdeploy"
  key_dir = ".keys/"
  environment_name = "${var.environment_name}"
  owner = "TEST"
  vpc_cidr = "${var.vpc_cidr}"
  public_subnet_cidr = "${var.public_subnet_cidr}"
  private_subnet_cidr = "${var.private_subnet_cidr}"
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
    subnet_id = "${module.vpc.private_subnet_id}"
    instance_type = "${var.instance_type}"
    key_name = "${module.vpc.key_name}"
    count =  1
    vpc_security_group_ids = [ "${module.vpc.security_group_ids}" ]
    tags {
      Name = "testing-instance-${count.index}"
      Owner = "TEST"
      Environment = "testing"
    }

    connection {
        user =  "${module.centos.image_user}"
        private_key = "${file(module.vpc.key_file)}"
        bastion_host = "${module.vpc.bastion_ip}"
        bastion_user = "${module.vpc.bastion_user}"
        bastion_private_key = "${file(module.vpc.key_file)}"
    }

    provisioner "remote-exec" {
        inline =  [
            "echo 'hello world' > test.txt"
        ]
    }
}
