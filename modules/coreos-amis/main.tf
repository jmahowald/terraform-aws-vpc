variable "channel" {
  default = "stable"
}

variable "virtualization_type" {
  default = "hvm"
}


data "aws_ami" "coreos" {
  most_recent = true
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "virtualization-type"
    values = ["${var.virtualization_type}"]
  }
  filter {
    name   = "name"
    values = ["CoreOS-${var.channel}-*"]
  }
}

output "ami_id" {
  value = "${data.aws_ami.coreos.image_id}"
}

output "image_user" {
  value = "core"
}
