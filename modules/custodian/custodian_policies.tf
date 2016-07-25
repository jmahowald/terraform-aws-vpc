variable "custodian_policy_dir" {
	default = "/opt/custodian/policies"
}

resource "template_file" "stop_policy" {
  # Read in the template file that is located with this module
  template = "${file("${path.module}/stop_policy.yml.tpl")}"
  vars {
    environment_name = "${var.environment_name}"
    owner = "${var.owner}"
  }
}

# Used for creating a local file.  Note that
# I think this might be able to be more fully modularized
# at least when we are able to pass maps of variables
resource "null_resource" "render_stop_policy" {
	# triggers are so that this can be reexecuted if
	# things change
	triggers = {
		environment_name = "${var.environment_name}"
		owner = "${var.owner}"
	}

	# somewhat hacky way of writing the file out
	provisioner "local-exec" {
    command = <<EOC_TERRAFORM
(
cat <<'EOP_SHELL'
${template_file.stop_policy.rendered}
EOP_SHELL
) > ${var.custodian_policy_dir}/stop_policy.yml

EOC_TERRAFORM
  }
}



resource "template_file" "start_policy" {
  # Read in the template file that is located with this module
  template = "${file("${path.module}/start_policy.yml.tpl")}"
  vars {
    environment_name = "${var.environment_name}"
    owner = "${var.owner}"
  }
}

# Used for creating a local file.  Note that
# I think this might be able to be more fully modularized
# at least when we are able to pass maps of variables
resource "null_resource" "render_start_policy" {
	# triggers are so that this can be reexecuted if
	# things change
	triggers = {
		environment_name = "${var.environment_name}"
		owner = "${var.owner}"
	}

	# somewhat hacky way of writing the file out
	provisioner "local-exec" {
    command = <<EOC_TERRAFORM
(
cat <<'EOP_SHELL'
${template_file.start_policy.rendered}
EOP_SHELL
) > ${var.custodian_policy_dir}/start_policy.yml

EOC_TERRAFORM
  }
}

