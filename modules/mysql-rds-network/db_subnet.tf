

variable "inbound_security_group_ids" {
  description = "This security group (like a private subnet) will be allowed access"
  type = "list"
}
variable "num_inbound_security_groups" {
  description = "How many security groups are we allowing to access the DB"
}

variable "subnet_ids" {
  type = "list"
}

variable "subnet_group_name" {
  default="rds-subnet"
}

variable "vpc_id" {}

output "db_subnet_group_name" {
    value = "${aws_db_subnet_group.default.name}"
}
output "security_group_id" {
    value = "${aws_security_group.db.id}"
}

resource "aws_db_subnet_group" "default" {
    name = "${var.subnet_group_name}"
    description = "Database VPC private subnets"
    subnet_ids = [ "${var.subnet_ids}"]
}

# Security group
resource "aws_security_group" "db" {
    name = "rds-incoming"
    description = "Allow servers to access database server."
    vpc_id = "${var.vpc_id}"
}


resource "aws_security_group_rule" "ingress" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = "${aws_security_group.db.id}"
  source_security_group_id = "${element(var.inbound_security_group_ids,count.index)}"
  count = "${var.num_inbound_security_groups}"
}


resource "aws_security_group_rule" "egress" {
  type = "egress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = "${element(var.inbound_security_group_ids,count.index)}"
  source_security_group_id = "${aws_security_group.db.id}"
  count = "${var.num_inbound_security_groups}"

}