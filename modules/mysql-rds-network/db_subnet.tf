## TODO - this isn't worthy of a module by itself any more, collapse it 
variable "subnet_ids" {
  type = "list"
}
variable "db_subnet_group_name" {
  default="rds-subnet"
}
output "db_subnet_group_name" {
    value = "${aws_db_subnet_group.default.name}"
}

resource "aws_db_subnet_group" "default" {
    name = "${var.db_subnet_group_name}"
    description = "Database VPC private subnets"
    subnet_ids = [ "${var.subnet_ids}"]
}
