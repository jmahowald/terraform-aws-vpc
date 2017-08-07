/**
 * This module takes in a bucket and a path and will create a user that can read that
 */

variable "path" {
   description = "The prefix within the bucket that will have access"
   default =   "*"
}

variable "bucket" {
    description = "The bucket to gran access to"
}

variable "serviceuser_name" {
    description = "name of the service user to create"
}

