

variable "security_group_ids" {
    type = "list"
}
variable "subnet_ids" {
  type = "list"
}

output "db_subnet_group_name" {
    value = "${aws_db_subnet_group.default.name}"
}
output "security_group_id" {
    value = "${aws_security_group.db.id}"
}

resource "aws_db_subnet_group" "default" {
    name = "d_subnet"
    description = "Database VPC private subnets"
    subnet_ids = [ "${var.subnet_ids}"]

}

# Security group
resource "aws_security_group" "db" {
    name = "d-SG"
    description = "Allow servers to access database server."
    vpc_id = "${var.vpc_id}"

    # Allow incoming trafic
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = "${var.inbound_security_group_ids}" 
    }
    lifecycle {
        create_before_destroy = true
    }
}
