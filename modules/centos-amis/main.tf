



variable "version" {}
variable "region" {}
variable "provider" {
	default = "aws"
}

output "ami_id" {
    value = "${lookup(var.centos_amis, format(\"%s-%s-%s\", var.version, var.provider, var.region))}"
}

output "image_user" {
	value = "${lookup(var.centos_users, var.version)}"
}

output "test" {
   value = "foo"
}
