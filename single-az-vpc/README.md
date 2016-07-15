

This project attempts to ease the creation of a relatively secure lab environment in AWS.  It will provision a new VPC with private and public subnets (in a single availabilty zone only for now), a NAT instance for those to be able to get resources from the internet without needing elastic IPs, and an openvpn server to remove the need for a bastion host, while still preserving some basic security.

This is heavily based off
of https://www.airpair.com/aws/posts/ntiered-aws-docker-terraform-guide


# Setup

This project uses

 * terraform - [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)


See what the lab would look like

	make plan

Create the new lab

	make apply

Destroy the lab

	make clean

See the dependencies

	terraform graph | dot -Tpng > graph.png


Due to how terraform evaluates items, we actually need to have the public key
created before.  Due to laziness on my part, that means you must setup
as environment variables with `TF_VAR_key_name` and `TF_VAR_key_dir`.  If you have
direnv setup, you can use the included .envrc


Terraform module to aid in the creation
of ssh keys.  You must supply `key_dir` and
`key_name` as environment variables with `TF_VAR_key_name` and `TF_VAR_key_dir`



# Storing Config To share

In order to share the output of this, without allowing others to necessarily overwrite, you can use a remote config after creating the lab (or use it during setup with terraform init which I've never done).  

There is a separate application `terraform_remote_s3bucket` than you can run make on.  It will
give in it's out the bucket name, and the bucket region


```
 terraform remote config -backend=s3 -backend-config="bucket=terraform-versioned-state" -backend-config="key=eu-central-1/lab/terraform.tfstate" -backend-config="region=us-east-1"
```
