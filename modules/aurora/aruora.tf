
variable "username" {
  default = "root"
}
variable "num_instances" {
    default = 1
}

variable "identifier_prefix" { 
    description = "Stat all instances with this"
}
variable "db_subnet_group_name" {}
variable "db_security_group" {}

variable "aurora_password" {}
variable "aurora_username" {
    default = "root"
}

variable "multi_az" {
  default = true
}

variable "dbname" { 
  default=""
}

variable "port" { 
  default = "3306"
 }
variable "instance_class" {
  default = "db.t2.small"
}
variable "backup_retention_period" {
   default = 30
}

data "aws_availability_zones" "available" {}
variable "num_azs" {
    description = "How many AZs should this be in"
    default = 2
}

# Database instance
resource "aws_rds_cluster" "default" {
    availability_zones = ["${slice(data.aws_availability_zones.available.names,0,var.num_azs)}"] 
    cluster_identifier_prefix = "${var.identifier_prefix}"
    //TODO figure out what the heck this means
    db_subnet_group_name = "${var.db_subnet_group_name}"
    vpc_security_group_ids = [
        "${var.db_security_group}"
    ]
    # Database details
    final_snapshot_identifier = "${var.identifier_prefix}-final"
    master_username = "${var.aurora_username}"
    master_password = "${var.aurora_password}"
    backup_retention_period = "${var.backup_retention_period}"
    lifecycle {
        create_before_destroy = true
    }
}

output "database_address" {
  value = "${aws_rds_cluster.default.endpoint}"
}

output "rds_identifier" {
  value= "${aws_rds_cluster.default.id}"
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = "${var.num_instances}"
  identifier         = "${var.identifier_prefix}-${count.index}"
  cluster_identifier = "${aws_rds_cluster.default.id}"
  instance_class = "${var.instance_class}"
}
