Terraform module to aid in the creation
of ssh keys.  You must supply `key_dir` and 
`key_name` as environment variables with `TF_VAR_key_name` and `TF_VAR_key_dir` 

You would also need to run make on this module so that the public key is created before terraform tries to interpolate it.  A sample makefile and module to call off are in the example directory.


