/* Define our vpc */
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "${var.environment}-vpc"
    Owner = "${var.owner}"
  }
}


/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

module "azs" {
  source = "availability_zones"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  public_subnet_cidrs = "${var.public_subnet_cidrs}"
  count = "${var.count}"
  internet_gateway_id = "${aws_internet_gateway.default.id}"
  owner = "${var.owner}"
}
