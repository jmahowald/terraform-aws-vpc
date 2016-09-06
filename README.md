This project attempts to ease the creation of a relatively secure lab environment in AWS.  It will provision a new VPC with private and public subnets (in a single availabilty zone only for now), a NAT instance for those to be able to get resources from the internet without needing elastic IPs, and an openvpn server to remove the need for a bastion host, while still preserving some basic security.

This is heavily based off
of https://www.airpair.com/aws/posts/ntiered-aws-docker-terraform-guide


# Setup

This project uses

 * terraform - [Install Terraform](https://www.terraform.io/intro/getting-started/install.html)

See what the lab would look like

	make plan

Create the new lab

	make vpc

Destroy the lab
	make clean

Due to how terraform evaluates items, we actually need to have the public key
created before.  Due to laziness on my part, that means you must setup
as environment variables with `TF_VAR_key_name` and `TF_VAR_key_dir`.  If you have
direnv setup, you can use the included .envrc or just set it in your profile

```
export TF_VAR_key_name=deploy_key
export TF_VAR_key_dir=~/.ssh`
```

These settings will make sure that a ~/.ssh/deploy_key.pem file
is created and will be used to login to machines.


# Storing Config To share

In order to share the output of this, without allowing others to necessarily overwrite, you can use a remote config after creating the lab (or use it during setup with terraform init which I've never done).  

There is a separate application `terraform_remote_s3bucket` than you can run make on.  It will
give in it's out the bucket name, and the bucket region

you

you can run `make remote` to store the remote state of the VPC
after first calling `make bucket`


By convention, we prefer to share the vpc information via a terraform remote state
That being said, it is useful to other terraform projects to bootstrap themselves
with the details on that bucket state.


Running `make bucket_vars` will result in a bucket.tfvars file being created
that you could use in your other projects.  Please note that this file
won't automatically get generated if your bucket information is changed
so you'll have to delete the bucket.tfvars file if you want it regenerated


# Layout philospophy
As of now, IMO there isn't a good way to conditionally include lab "features".
As such, there are two types of terraform "projects" included within
module have most of the business logic within them, and top level "applications"
can use those modules.  In order to share information, we are using the remote
config in all 'apps' other than the vpc itself


# Using the vpn

Run `make vpn` to create a vpn endpoint on the jump host

this will also result in the creation of scripts in the openvpn directory

Run `openvpn/bin/ovpn-init` to provision the vpn initially (TODO add to make)
This script will ask you three times for a password for the CA, and you will need
that password later on if you create a client cert


Run `openvpn/bin/ovpn-new-client <user>` to create a new openvpn profile for the user
This will require the password you set for the CA when you initialized


Run `openvpn/bin/ovpn-get-client-config <user>` to dowload an openvpn profile

# Creating a VPC with a couple hosts and bastions to goo with them.

git@git.genesyslab.com:infrastructure/terraform-aws-vpc.git
        multiaz branch (I should merge to master)
        if you jump into the workstation

docker run -it --rm \   -v $(pwd):/workspace \   -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \   -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \   -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \     genesysarch/cloud-workstation

run that in that directory.
cd tests
make plan;make apply

Okay the above did not quite work for me - so once the container is running
ssh to it do to the gencloud/workstation
run aws configure add the keys there, then cd tests and make plan; make apply.




# Sharing the state
