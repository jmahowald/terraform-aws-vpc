

variable "owner_id" {
  default = "AAAAA"
}

module "vpc_1" {
  source = "../../../tests"
  vpc_cidr = "10.40.0.0/16"
  public_subnet_cidr = "10.40.1.0/24"
  private_subnet_cidr = "10.40.2.0/24"
}

module "vpc_2" {
  source = "../../../tests"
  vpc_cidr =  "192.168.0.0/16"
  public_subnet_cidr = "192.168.1.0/24"
  private_subnet_cidr = "192.168.2.0/24"
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
/*
variable "peer_vpc_id" {}
variable "peer_owner_id" {}
variable "vpc_id" {}
variable "peer_cidr" {}*/
