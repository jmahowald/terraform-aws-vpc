

variable "vpc1_cidr" {
  default = "10.40.0.0/16"
}

output "subnet" {
  value = "${null_resource.dummy.triggers.subnet}"
}

resource "null_resource" "dummy" {
  triggers {
    subnet = "${cidrsubnet(var.vpc1_cidr,8,2)}"
  }
}
