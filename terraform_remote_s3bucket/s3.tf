variable "bucket_name" {
  default = "terraform-versioned-state"
}

resource "aws_s3_bucket" "terraform_versioned_state" {
    bucket = "${var.bucket_name}"
    acl = "private"
    versioning {
      enabled = true
    }

    /**
     * Dont' keep around all old versions forever
     */
    lifecycle_rule {
        prefix = "config/"
        enabled = true
        noncurrent_version_transition {
            days = 30
            storage_class = "STANDARD_IA"
        }
        noncurrent_version_transition {
            days = 60
            storage_class = "GLACIER"
        }
        noncurrent_version_expiration {
            days = 90
        }
    }
}



output "bucket_region" {
  value = "${aws_s3_bucket.terraform_versioned_state.region}"
}
output "arn" {
  value = "${aws_s3_bucket.terraform_versioned_state.arn}"
}
output "name" {
  value = "${aws_s3_bucket.terraform_versioned_state.id}"
}
