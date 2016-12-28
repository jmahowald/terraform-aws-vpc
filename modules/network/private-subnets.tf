
/* private subnet */
resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.default.id}"
  count = "${var.availability_zone_count}"
  cidr_block = "${element(var.private_subnet_cidrs,count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = false
  tags {
    Name = "private ${var.environment} - ${count.index}"
    Owner = "${var.owner}"
  }
}



/* Associate the routing table to private subnet */

resource "aws_route_table_association" "private" {
  count = "${var.availability_zone_count}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table" "private" {
  lifecycle {
    create_before_destroy = "true"
  }
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${element(aws_instance.jump.*.id,count.index)}"
  }
  tags {
    Name = "private ${var.environment} - ${count.index}"
    Owner = "${var.owner}"
  }

}
