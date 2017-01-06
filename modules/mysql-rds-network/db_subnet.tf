

variable "inbound_security_group_id" {
  description = "This security group (like a private subnet) will be allowed access"
}

variable "subnet_ids" {
  type = "list"
}

variable "vpc_id" {}

output "db_subnet_group_name" {
    value = "${aws_db_subnet_group.default.name}"
}
output "security_group_id" {
    value = "${aws_security_group.db.id}"
}

resource "aws_db_subnet_group" "default" {
    name = "rds-subnet"
    description = "Database VPC private subnets"
    subnet_ids = [ "${var.subnet_ids}"]
}

# Security group
resource "aws_security_group" "db" {
    name = "rds-incoming"
    description = "Allow servers to access database server."
    vpc_id = "${var.vpc_id}"
}


resource "aws_security_group_rule" "privatesubnet" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = "${aws_security_group.db.id}"
  source_security_group_id = "${var.inbound_security_group_id}"
}
