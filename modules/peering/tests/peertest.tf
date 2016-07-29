module "vpc_test" {
  source = "../../../tests"

}
module "peering" {
    source = "../"
    peer_vpc_id = "vpc-9ec493fa"
    peer_owner_id = "667434029862"
    peer_cidr = "192.168.0.0/16"
    vpc_id = "${module.vpc_test.vpc_id}"
}
/*
variable "peer_vpc_id" {}
variable "peer_owner_id" {}
variable "vpc_id" {}
variable "peer_cidr" {}*/
