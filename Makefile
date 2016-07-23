
all: plan apply

export TF_VAR_aws_region=$(AWS_DEFAULT_REGION)
export TF_VAR_FILE ?=$(shell pwd)/terraform.tfvars




# this hacky section is to allow us to store terraform state for the
# vpc in a bucket, but not have the project create the bucket istself
# as the deletion of the bucket during a clean phase is disastrous.
# This is most likely overengineered
BUCKET_STATE=$(shell pwd)/terraform_remote_s3bucket/terraform.tfstate

ifneq ($(wildcard $(BUCKET_STATE)),)

export BUCKET_NAME=$(shell terraform output --state=$(BUCKET_STATE) name)
export BUCKET_REGION=$(shell terraform output --state=$(BUCKET_STATE) bucket_region)
remote:
	make -C single-az-vpc remote
else
remote:
	$(info you must explicitly call make bucket first)
endif




#
# # If there is a terraform.tfvars, we can pass that on to submodules
# # who by convention will append TF_VAR_ARGS to plan and destroy commands
# ifneq ($(wildcard $(TF_VARS)),)
# export TF_VAR_ARGS="--var-file=$(shell pwd)/$(TF_VARS)"
# endif

vpc:
	make -C single-az-vpc

bucket:
	make -C terraform_remote_s3bucket

plan:
	make -C single-az-vpc plan

clean:
	make -C single-az-vpc clean
