Terraform module to aid in the creation
of ssh keys.  You must supply `key_dir` and 
`key_name` as terraform variables.  Please note
that like all terraform variables you can do this by
either having a terraform.tfvars file or having
environment variables prepended with TF_VAR.


This will create a private key and public key and upload to AWS