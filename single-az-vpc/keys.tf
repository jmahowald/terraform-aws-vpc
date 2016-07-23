
# Key creation section
# When creating the key, what name should it have
variable "key_name" {
  default = "deploykey"
}
# Where to store the key
variable "key_dir" {
  default = "~/.keys"
}

output "key_file" {
  value =   "${module.keys.key_path}"
}


module "keys" {
  source = "../modules/keys"
  key_name="${var.key_name}"
  key_dir="${var.key_dir}"
}
