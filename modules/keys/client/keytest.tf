module "key" {
   source="git::ssh://git@git.genesyslab.com/infrastructure/terraform-aws-keys.git"
   key_dir = "~/.keys"
   key_name= "test"
}
