
/* Public subnet */
resource "aws_subnet" "public" {

  lifecycle {
    create_before_destroy = "true"
  }
  vpc_id = "${var.vpc_id}"
  count = "${var.count}"
  cidr_block = "${element(var.public_subnet_cidrs,count.index)}"
  //In terraform 0.7 won't need to do this split nonsense and can pass around
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "public ${var.environment} - ${count.index}"
    Owner = "${var.owner}"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"
  count = "${var.count}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet_gateway_id}"
  }
  tags {
    Name = "public ${var.environment} - ${count.index}"
    Owner = "${var.owner}"
  }

}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "public" {
  count = "${var.count}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}
