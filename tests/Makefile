PHONY:
all: plan apply

# Most of our other work is in us-west-1 or us-east-1. Let's explicitly
# set a differnet region

# You can override where these occur by setting TF_TESTING_REGION
TF_TESTING_REGION ?= us-west-2
export AWS_DEFAULT_REGION = $(TF_TESTING_REGION)
export TF_VAR_aws_region = $(TF_TESTING_REGION)
export TF_VAR_key_name = testingdeploy
export TF_VAR_key_dir = $(shell pwd)/.keys
export TF_VAR_FILE ?=$(shell pwd)/terraform.tfvars

# If there is a terraform.tfvars
# use that as terraform input
# rather than depend on environment variables or user input
TF_VAR_ARGS ?=
ifneq ($(wildcard $(TF_VAR_FILE)),)
TF_VAR_ARGS=--var-file=$(TF_VAR_FILE)
endif

TF_FILES=$(wildcard *.tf)

.terraform: $(TF_FILES)
	terraform get --update
	for i in $$(ls .terraform/modules/*/Makefile); do i=$$(dirname $$i); echo "Trying make in $$i"; make -C $$i; done

plan: $(TF_FILES) .terraform
	terraform plan -out terraform.tfplan $(TF_VAR_ARGS)

refresh:
	terraform refresh $(TF_VAR_ARGS)
terraform.tfplan: $(TF_FILES) .terraform
	$(MAKE) plan

apply: terraform.tfplan
	terraform apply terraform.tfplan

clean:
	terraform destroy -force $(TF_VAR_ARGS)
	rm -rf .terraform
	rm -rf terraform.tfstate
	rm -rf terraform.tfplan

destroy:
	terraform destroy $(TF_VAR_ARGS)

test: plan apply
	./inttest.sh
	$(MAKE) clean
