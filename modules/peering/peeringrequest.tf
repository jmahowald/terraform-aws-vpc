variable "peer_vpc_id" {}
variable "peer_owner_id" {}
variable "vpc_id" {}


output "peering_id" {
  value = "${aws_vpc_peering_connection.peer.id}"
}

resource "aws_vpc_peering_connection" "peer" {
    peer_owner_id = "${var.peer_owner_id}"
    peer_vpc_id = "${var.peer_vpc_id}"
    vpc_id = "${var.vpc_id}"
}
