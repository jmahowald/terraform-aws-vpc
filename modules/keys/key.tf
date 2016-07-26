
variable "key_name" {}
variable "key_dir" {}


/* and our deployment keys */
resource "aws_key_pair" "deployer" {
  depends_on = ["null_resource.key_creation_exec"]
  key_name = "${var.key_name}" 
  public_key =  "${file("${var.key_dir}/${var.key_name}.pub")}"
}

output "key_name" {
  value = "${var.key_name}"
}

output "key_path" {
  value = "${var.key_dir}/${var.key_name}.pem"
}


/**
output "pem_key_path" {
  value = "${var.key_dir}/${var.key_name}.pem"
}
**/

/**
 * Calls off to Make to do the heavy lifting for 
 * generating a key pair. 
 */
resource "null_resource" "key_creation_exec" {
  provisioner "local-exec" {
  	command =  "TF_VAR_key_name=${var.key_name} TF_VAR_key_dir=${var.key_dir} make -C ${path.module}"
  } 
  # recreates if either of these change
  triggers {
  	key_dir = "${var.key_dir}"
  	key_name = "${var.key_name}"
  }
}