variable "peer_vpc_id" {}
variable "peer_owner_id" {}
variable "vpc_id" {}
variable "peer_cidr" {}

resource "aws_vpc_peering_connection" "peer" {
    peer_owner_id = "${var.peer_owner_id}"
    peer_vpc_id = "${aws_vpc.bar.id}"
    vpc_id = "${var.vpc_id}"
}

output "peering_id" {
  value = "${aws_vpc_peering_connection.peer.id}"
}

vpc_id = "${aws_vpc.default.id}"
route {
    cidr_block = "10.0.1.0/24"
    gateway_id = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table" "peer_route" {
    vpc_id = "${var.vpc_id}"
    route {
        cidr_block = "${var.peer_cidr}"
        vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
    }
    tags {
        Name = "peer route"
    }
}
