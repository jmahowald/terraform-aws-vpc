
 variable "cidr_base" {
     default = "10.0.0.0/8"
     description = "what's the initial ip range"
 } 
  

variable "region_number" {
    default = 1
}

// https://github.com/hashicorp/terraform/issues/4084#issuecomment-236429459

data "null_data_source" "vpc_base" {
    inputs  {
        region = "${cidrsubnet(var.cidr_base,8, var.region_number * 100)}"
    }
}

output "vpc_cidr" {
    value = "${data.null_data_source.vpc_base.inputs.region}"
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
        pub_az1 = "${cidrsubnet(data.null_data_source.vpc_base.inputs.region, 8, 0)}"
        pub_az2 = "${cidrsubnet(data.null_data_source.vpc_base.inputs.region, 8, 1)}"
        pub_az3 = "${cidrsubnet(data.null_data_source.vpc_base.inputs.region, 8, 2)}"        
        priv_az1 = "${cidrsubnet(data.null_data_source.vpc_base.inputs.region, 8, 10)}"
        priv_az2 = "${cidrsubnet(data.null_data_source.vpc_base.inputs.region, 8, 11)}"
        priv_az3 = "${cidrsubnet(data.null_data_source.vpc_base.inputs.region, 8, 12)}"

    }
}
