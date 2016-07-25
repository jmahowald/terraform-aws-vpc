variable "bucket_name" {
  default = "terraform-versioned-state"
}
variable "bucket_region"{}
variable "bucket_key"{}

resource "terraform_remote_state" "lab" {
    backend = "s3"
    config {
        bucket = "${var.bucket_name}"
        # The bucket is in us east wher we store the state
        # (we actually don't have control of where the bucket will be created)
        region = "${var.bucket_region}"
        # But the key by convention includes the region the lab is setup for"
        key = "${var.bucket_key}"
    }
}

module "vpn" {
  source = "../modules/vpn"
  host_address = "${terraform_remote_state.lab.output.bastion_ip}"
  host_user = "${terraform_remote_state.lab.output.bastion_user}"
  ssh_keypath = "${terraform_remote_state.lab.output.key_file}"
  vpn_cidr = "${terraform_remote_state.lab.output.vpc_cidr}"
}
