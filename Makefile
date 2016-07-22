
all: plan apply


TF_VARS=terraform.tfvars

#When we enable remote state on a terraform project,the
#.tfstate file goles
export BUCKET_STATE=$(shell pwd)/terraform_remote_s3bucket/terraform.tfstate


# If there is a terraform.tfvars, we can pass that on to submodules
# who by convention will append TF_VAR_ARGS to plan and destroy commands
ifneq ($(wildcard $(TF_VARS)),)
	TF_VAR_FILE=$(shell pwd)/$(TF_VARS)
	export TF_VAR_ARGS= --var-file=$(TF_VAR_FILE)
endif

vpc:
	make -C single-az-vpc

BUCKET_STATE:
	make -C terraform_remote_s3bucket

remote: vpc $(BUCKET_STATE)
	make -C single-az-vpc remote

plan:
	make -C single-az-vpc plan

clean:
	make -C single-az-vpc clean
