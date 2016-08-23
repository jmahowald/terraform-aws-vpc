variable "private_subnet_cidrs" {
  type="list"
}
/* private subnet */
resource "aws_subnet" "private" {
  vpc_id = "${var.vpc_id}"
  count = "${var.count}"
  cidr_block = "${element(var.private_subnet_cidrs,count.index)}"
  //In terraform 0.7 won't need to do this split nonsense and can pass around
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "private ${var.environment} - ${count.index}"
    Owner = "${var.owner}"
  }
}



/* Associate the routing table to private subnet */

resource "aws_route_table_association" "private" {
  count = "${var.count}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}


resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${element(aws_instance.jump.*.id,count.index)}"
  }
  tags {
    Name = "private ${var.environment} - ${count.index}"
    Owner = "${var.owner}"
  }

}


output "private_route_table_ids" {
    value = ["${aws_route_table.private.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}
