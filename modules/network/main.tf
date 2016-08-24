
/* Security group for the nat server */
resource "aws_security_group" "public" {
  name = "${var.environment}-lab-public"
  description = "Security group for nat instances that allows SSH and jump traffic from internet."
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "${var.environment}-public-sg"
  }
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  security_group_id = "${aws_security_group.public.id}"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "public_to_private_ssh" {
  type = "egress"
  security_group_id = "${aws_security_group.public.id}"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.private.id}"
}


resource "aws_security_group_rule" "http_in" {
  type = "ingress"
  security_group_id = "${aws_security_group.public.id}"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_in" {
  type = "ingress"
  security_group_id = "${aws_security_group.public.id}"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

// TODO in some environments, you might not even allow this much
resource "aws_security_group_rule" "public_http_out" {
    type = "egress"
    security_group_id = "${aws_security_group.public.id}"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_https_out" {
    type = "egress"
    security_group_id = "${aws_security_group.public.id}"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}


/** NAT instances should be able to ssh into the private instances */
resource "aws_security_group" "private" {
  name = "${var.environment}-private"
  description = "Security group for private instances allowing the bastion hosts in"
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "${var.environment}-private-sg"
  }
}

resource "aws_security_group_rule" "from_bastion" {
  security_group_id = "${aws_security_group.private.id}"
  type = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.public.id}"
}

resource "aws_security_group_rule" "to_nat" {
  security_group_id = "${aws_security_group.private.id}"
  type = "egress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.public.id}"
}


resource "aws_security_group_rule" "internal_in" {
  security_group_id = "${aws_security_group.private.id}"
  type = "ingress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.private.id}"
}

resource "aws_security_group_rule" "internal_out" {
  security_group_id = "${aws_security_group.private.id}"
  type = "egress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.private.id}"
}


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



data "aws_availability_zones" "available" {}
