variable "vpc_id"{}
variable "environment_name"  {}

output "security_group_ids" {
  value = ["${aws_security_group.default.id}"]
}
# TODO This probably is more open than it should be and could be extracted out
resource "aws_security_group" "default" {
  name = "${var.environment_name}-openvpc-sg"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  tags {
    Name = "${var.environment_name}-openvpc-sg"
  }
}
