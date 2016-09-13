
# description


A module to faciliate vpc peering between different VPCs
by creating a peering request and the necessary route tables


# Usage

Use the folowing terraform (details on how to set variables, install terraform,
and run on request)

```


# Account number of the peer vpc
variable "peer_owner_id" {}
variable "vpc1_id" {}
variable "vpc1_private_subnet_id" {}
variable "vpc1_private_route_table_id" {}

variable "vpc2_id" {}
variable "vpc2_cidr" {
  default = "10.50.0.0/20"
}

module "peering" {
  source="it::ssh://git@git.genesyslab.com/infrastructure/terraform-aws-vpc//modules/peering"
    peer_vpc_id = "${var.vpc2_id}"
    peer_owner_id = "${var.peer_owner_id}"
    vpc_id = "${var.vpc1_id}"
}

module "peer_route_1" {
  vpc_id="${var.vpc1_id}"
  source="it::ssh://git@git.genesyslab.com/infrastructure/terraform-aws-vpc//modules/peering/routing"
  source = "../routing"
  subnet_id = "${var.vpc1_private_subnet_id}"
  route_table_id = "${{var.vpc1_private_route_table_id}"
  peer_cidr = "${var.vpc2_cidr}"
  peering_connection_id = "${module.peering.peering_id}"
}

```


You'll also need to setup security groups to the peered vpc.  For instance"

```

resource "aws_security_group" "allow_all_from_vpc_2" {
  name = "allow_all_vpc2"
  description = "Allow all inbound traffic"
  vpc_id = "${var.vpc1_id}"
  ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = [
        "${var.vpc2_cidr}"
      ]
  }
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [
      "${var.vpc2_cidr}"
    ]
  }
  tags {
    Name = "allow_all"
  }
}

```
