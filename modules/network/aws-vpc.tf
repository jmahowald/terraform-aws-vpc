/* Define our vpc */
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_base_ip}.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "${var.environment_name}-vpc"
  }
}
