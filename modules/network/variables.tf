
// Find them all with  aws ec2 describe-availability-zones --region <region name>
variable aws_azs {
  default = {
    us-east-1 = "us-east-1a,us-east-1c,us-east-1d"
    us-west-2 = "us-west-2a,us-west-2b,us-west-2c"
    us-west-1 = "us-west-1a,us-west-1b,us-west-1c"
  }
}

variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
}
variable "private_subnet_cidrs" {
}


# In Terraform 0.7 we can replace that with this
/*data "aws_availability_zones" "available" {}*/



variable "count" {
  default = "1"
}
variable "aws_region" {}
