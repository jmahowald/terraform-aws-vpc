

variable "owner_id" {
  default = "AAAAA"
}
variable "key_name" {
  default = "testingdeploy"
}
variable "aws_availability_zone" {
  default = "us-west-2a"
}
variable "aws_region" {
  default = "us-west-2"
}

output "bastion_ip_1" {
  value = "${module.vpc_1.bastion_ip}"
}
output "bastion_ip_2" {
  value = "${module.vpc_2.bastion_ip}"
}
output "bastion_user_1" {
  value = "${module.vpc_1.bastion_user}"
}
output "bastion_user_2" {
  value = "${module.vpc_2.bastion_user}"
}
output "image_user" {
  value = "${module.centos.image_user}"
}
output "test_ip_1" {
  value = "${aws_instance.test.private_ip}"
}
output "test_ip_2" {
  value = "${aws_instance.test2.private_ip}"
}
output "key_file" {
  value = "${module.keys.key_path}"
}

module "keys" {
  source = "../../keys"
  key_dir = ".keys/"
  key_name = "${var.key_name}"
}

module "centos" {
  #TODO this should be core os?
  source = "../../centos-amis"
  version = "7"
  region = "${var.aws_region}"
}

variable "private_vpc1_subnet_cidr"  {
  default = "10.40.2.0/24"
}

variable "private_vpc2_subnet_cidr" {
  default = "192.168.2.0/24"
}


module "vpc_1" {
  source = "../../network"
  vpc_cidr = "10.40.0.0/16"
  public_subnet_cidr = "10.40.1.0/24"
  private_subnet_cidr = "${var.private_vpc1_subnet_cidr}"
  aws_availability_zone = "${var.aws_availability_zone}"
  key_name = "${var.key_name}"
  ssh_keypath = "${module.keys.key_path}"
  environment_name = "peer test"
  image_user = "${module.centos.image_user}"
  ami = "${module.centos.ami_id}"
  aws_region = "${var.aws_region}"
  owner = "Tester"
}


module "vpc_2" {
  source = "../../network"
  vpc_cidr =  "192.168.0.0/16"
  public_subnet_cidr = "192.168.1.0/24"
  private_subnet_cidr = "${var.private_vpc2_subnet_cidr}"
  key_name = "${var.key_name}"
  aws_availability_zone = "${var.aws_availability_zone}"
  ssh_keypath = "${module.keys.key_path}"
  environment_name = "peer test"
  image_user = "${module.centos.image_user}"
  ami = "${module.centos.ami_id}"
  aws_region = "${var.aws_region}"
  owner = "Tester"
}





resource "aws_security_group" "allow_all_from_vpc_2" {
  name = "allow_all_vpc2"
  description = "Allow all inbound traffic"
  vpc_id = "${module.vpc_1.vpc_id}"
  ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = [
        "${var.private_vpc2_subnet_cidr}"
      ]
  }
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [
      "${var.private_vpc2_subnet_cidr}"
    ]
  }
  tags {
    Name = "allow_all"
  }
}

resource "aws_security_group" "allow_all_from_vpc_1" {
  name = "allow_all_vpc1"
  description = "Allow all inbound traffic"
  vpc_id = "${module.vpc_2.vpc_id}"

  ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = [
        "${var.private_vpc1_subnet_cidr}"
      ]
  }
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [
      "${var.private_vpc1_subnet_cidr}"
    ]

  }
  tags {
    Name = "allow_all"
  }
}


module "peering_1" {
    source = "../"
    peer_vpc_id = "${module.vpc_2.vpc_id}"
    peer_owner_id = "${var.owner_id}"
    peer_cidr = "192.168.0.0/16"
    vpc_id = "${module.vpc_1.vpc_id}"
}


module "peering_2" {
    source = "../"
    peer_vpc_id = "${module.vpc_1.vpc_id}"
    peer_owner_id = "${var.owner_id}"
    peer_cidr = "10.40.0.0/16"
    vpc_id = "${module.vpc_2.vpc_id}"
}




resource "aws_instance" "test" {
    availability_zone = "${var.aws_availability_zone}"
    ami = "${module.centos.ami_id}"
    subnet_id = "${module.vpc_1.private_subnet_id}"
    instance_type = "t2.micro"
    key_name = "${module.keys.key_name}"
    count =  1
    vpc_security_group_ids = [ "${module.vpc_1.security_group}",
      "${aws_security_group.allow_all_from_vpc_2.id}"]
    tags {
      Name = "testing-instance-${count.index}"
      Owner = "TEST"
      Environment = "testing"
    }

    connection {
        user =  "${module.centos.image_user}"
        agent = false
        private_key = "${file(module.keys.key_path)}"
        bastion_host = "${module.vpc_1.bastion_ip}"
        bastion_user = "${module.vpc_1.bastion_user}"
        #bastion_private_key = "${file(module.vpc.key_file)}"
    }

    provisioner "remote-exec" {
        inline =  [
            "echo 'hello world' > test.txt",
            "yum install nc"
        ]
    }
}


resource "aws_instance" "test2" {
    availability_zone = "${var.aws_availability_zone}"
    ami = "${module.centos.ami_id}"
    subnet_id = "${module.vpc_2.private_subnet_id}"
    instance_type = "t2.micro"
    key_name = "${module.keys.key_name}"
    count =  1
    vpc_security_group_ids = [ "${module.vpc_2.security_group}",
    "${aws_security_group.allow_all_from_vpc_1.id}" ]
    tags {
      Name = "testing-instance-${count.index}"
      Owner = "TEST"
      Environment = "testing"
    }

    connection {
        user =  "${module.centos.image_user}"
        agent = false
        private_key = "${file(module.keys.key_path)}"
        bastion_host = "${module.vpc_2.bastion_ip}"
        bastion_user = "${module.vpc_2.bastion_user}"
        #bastion_private_key = "${file(module.vpc.key_file)}"
    }

    provisioner "remote-exec" {
        inline =  [
            "echo 'hello world' > test.txt",
            "yum install nc"

        ]
    }
}

/*
variable "peer_vpc_id" {}
variable "peer_owner_id" {}
variable "vpc_id" {}
variable "peer_cidr" {}*/
