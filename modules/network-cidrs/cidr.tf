
 variable "cidr_base" {
     default = "10.0.0.0/8"
     description = "what's the initial ip range"
 } 

variable "subnet_increment" {
    default = 8
}

// https://github.com/hashicorp/terraform/issues/4084#issuecomment-236429459

output "vpc_cidr" {
    value = "${var.cidr_base}"
}

output "public_cidrs" {
    value = ["${data.null_data_source.cidrs.inputs.pub_az1}",
    "${data.null_data_source.cidrs.inputs.pub_az2}",
    "${data.null_data_source.cidrs.inputs.pub_az3}"]
}

output "private_cidrs" {
    value = ["${data.null_data_source.cidrs.inputs.priv_az1}",
    "${data.null_data_source.cidrs.inputs.priv_az2}",
    "${data.null_data_source.cidrs.inputs.priv_az3}"]
}

data "null_data_source" "cidrs" {
    inputs {
        pub_az1 = "${cidrsubnet(var.cidr_base, var.subnet_increment, 0)}"
        pub_az2 = "${cidrsubnet(var.cidr_base, var.subnet_increment, 1)}"
        pub_az3 = "${cidrsubnet(var.cidr_base, var.subnet_increment, 2)}"
        priv_az1 = "${cidrsubnet(var.cidr_base, var.subnet_increment, 10)}"
        priv_az2 = "${cidrsubnet(var.cidr_base, var.subnet_increment, 11)}"
        priv_az3 = "${cidrsubnet(var.cidr_base,  var.subnet_increment, 12)}"

    }
}

resource "null_resource" "foo" {}
