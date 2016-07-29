
/* Public subnet */
resource "aws_subnet" "public" {
  vpc_id = "${var.vpc_id}"
  count = "${var.count}"
  cidr_block = "${element(split(",","${var.public_subnet_cidrs}"))}"
  //In terraform 0.7 won't need to do this split nonsense and can pass around
  availability_zone = "${element(split(",","${module.az.list_all}", count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "public ${var.environment_name} - ${count.index}"
    Owner = "${var.owner}"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "public" {
  count = "${var.count}"
  subnet_id = "${element(aws_subnet.public.*.id)}"
  route_table_id = "${aws_route_table.public.id}"
}