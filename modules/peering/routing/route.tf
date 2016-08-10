variable "vpc_id"{}
variable "peer_cidr"{}
variable "peering_connection_id"{}
variable "subnet_id"{}
variable "route_table_id"{}

resource "aws_route" "r" {
    route_table_id = "${var.route_table_id}"
    destination_cidr_block = "${var.peer_cidr}"
    vpc_peering_connection_id = "${var.peering_connection_id}"
}
