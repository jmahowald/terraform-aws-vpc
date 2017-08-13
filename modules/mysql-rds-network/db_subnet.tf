
variable "subnet_ids" {
  type = "list"
}
variable "db_subnet_group_name" {
  default="mysql-subnet"
}
output "db_subnet_group_name" {
    value = "${aws_db_subnet_group.default.name}"
}
resource "aws_db_subnet_group" "default" {
    name = "${var.db_subnet_group_name}"
    description = "Database VPC private subnets"
    subnet_ids = [ "${var.subnet_ids}"]
}

data "aws_subnet" "selected" {
  id = "${element(var.subnet_ids,0)}"
}
data "aws_vpc" "vpc" {
    id = "${data.aws_subnet.selected.vpc_id}"
}

variable "inbound_security_group_ids" { 
  type="list"
}
variable "port" {
  default = "3306"
}
variable "environment" {}


output "security_group_id" {
  value = "${aws_security_group.db.id}"
}

# Security group
resource "aws_security_group" "db" {
    name = "${var.environment}-rds-incoming"
    description = "Allow servers to access database server."
    vpc_id = "${data.aws_vpc.vpc.id}"
    lifecycle {
      create_before_destroy = true
    }
}


resource "aws_security_group_rule" "ingress" {
  type = "ingress"
  from_port = "${var.port}"
  to_port = "${var.port}"
  protocol = "tcp"
  security_group_id = "${aws_security_group.db.id}"
  source_security_group_id = "${element(var.inbound_security_group_ids,count.index)}"
  count = "${length(var.inbound_security_group_ids)}"
}

resource "aws_security_group_rule" "egress" {
  type = "egress"
  from_port = "${var.port}"
  to_port = "${var.port}"
  protocol = "tcp"
  security_group_id = "${element(var.inbound_security_group_ids,count.index)}"
  source_security_group_id = "${aws_security_group.db.id}"
  count = "${length(var.inbound_security_group_ids)}"
}