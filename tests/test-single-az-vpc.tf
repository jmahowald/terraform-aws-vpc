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

variable "owner_name" {
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



/* Define our vpc */
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "${var.environment_name}-vpc"
    Owner = "${var.owner_name}"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}



module "vpc" {

  vpc_id = "${aws_vpc.default.id}"
  internet_gateway_id  = "${aws_internet_gateway.default.id}"
  ami = "${module.centos.ami_id}"
  image_user = "${module.centos.image_user}"
  aws_region = "${var.aws_region}"
  /*aws_availability_zone = "${var.aws_availability_zone}"*/
  source = "../modules/network/availability_zones"
  key_name = "testingdeploy"
  ssh_keypath = "${module.keys.key_path}"
  environment = "${var.environment_name}"
  owner =  "${var.owner_name}"
  count=1
  public_subnet_cidrs = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  jumphost_security_group_ids = "${module.security_groups.security_group_ids}"
}

module "security_groups" {
  environment_name = "${var.environment_name}"
  source = "../modules/security_groups/all_vpc"
  vpc_id = "${aws_vpc.default.id}"

}

module "keys" {
  source = "../modules/keys"
  key_dir = ".keys/"
  key_name = "${var.key_name}"
}

output vpc_id {
  value = "${aws_vpc.default.id}"
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
      Owner = "${var.owner_name}"
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
