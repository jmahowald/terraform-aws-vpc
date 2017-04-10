
variable "key_name" {}
variable "public_key" {}
variable "region" {}
provider "aws" {
  region = "${var.region}"
}

/* and our deployment keys */
resource "aws_key_pair" "deployer" {
  key_name = "${var.key_name}" 
  public_key =  "${var.public_key}"
}

/*
 * We reoutput from the key pair so that others can depend on this and wait until key creation is done
 */
output "key_name" {
  value = "${aws_key_pair.deployer.key_name}"
}