/**
 * This module is a very simple wrapper around tls_private_key that can be used to idempotently create ssh keys for environments
 */

variable "key_name" { description = "what is the logicname of the key" }
variable "key_dir" { 
  description = "what directory should the key be stored in"
  default = "keys" 
}



data "null_data_source" "keyinfo" {
  inputs {
    key_path = "${var.key_dir}/${var.key_name}.pem"
  }
}

resource "tls_private_key" "key" {
  algorithm   = "RSA"
  provisioner "local-exec" {
    command = <<EOC_TERRAFORM
mkdir -p ${var.key_dir}
chmod 700 ${var.key_dir}
(
cat <<'EOP_SHELL'
${self.private_key_pem}
EOP_SHELL
) > ${data.null_data_source.keyinfo.inputs.key_path}
chmod 400 ${data.null_data_source.keyinfo.inputs.key_path}
EOC_TERRAFORM
  }
}


output "public_key" {
  value =  "${tls_private_key.key.public_key_openssh}"
}

output "key_path" {
  value = "${data.null_data_source.keyinfo.inputs.key_path}"
}



