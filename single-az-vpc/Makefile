
all: apply


# There is a bug in terraform v 16
# https://github.com/hashicorp/terraform/issues/6758#issuecomment-220229768
# around the use of elastic ips that consistently makes it difficult
# to destroy the environment
# as such, we will error out if it's that version
TERRAFORM_VERSION = $(shell terraform version)
ifneq (,$(findstring 0.6.16, $(TERRAFORM_VERSION)))
$(error "Can't use 6.16 terraform")
endif


# If there is a terraform.tfvars
# use that as terraform input
# rather than depend on environment variables or user input
TF_VAR_ARGS ?=
ifdef TF_VAR_FILE
ifneq ($(wildcard $(TF_VAR_FILE)),)
TF_VAR_ARGS=--var-file=$(TF_VAR_FILE)
endif
endif


TF_FILES=$(wildcard *.tf)
.terraform: $(TF_FILES)
	terraform get --update
	for i in $$(ls .terraform/modules/*/Makefile); do i=$$(dirname $$i); echo "Trying make in $$i"; make -C $$i; done

plan: $(TF_FILES) .terraform
	terraform plan -out terraform.tfplan $(TF_VAR_ARGS)

terraform.tfplan: $(TF_FILES) .terraform
	$(MAKE) plan

apply: terraform.tfplan
	terraform apply terraform.tfplan

clean: destroy
	#rm -rf .terraform
	#rm -rf terraform.tfstate
	rm -rf terraform.tfplan

destroy:
	terraform destroy $(TF_VAR_ARGS)


#
# # If there is a terraform.tfvars, we can pass that on to submodules
# # who by convention will append TF_VAR_ARGS to plan and destroy commands
# ifneq ($(wildcard $(TF_VARS)),)
# 	TF_VAR_ARGS="--var-file=$(shell pwd)/$(TF_VARS)"
# endif

BUCKET_REGION ?=
BUCKET_NAME ?=
ifdef BUCKET_NAME
remote: $(VPC_REMOTE_STATE_FILE)
	terraform remote config -backend=s3 \
	-backend-config="bucket=$(BUCKET_NAME)" \
	-backend-config="key=$(shell terraform output aws_region)/vpc/terraform.tfstate" \
	-backend-config="region=$(BUCKET_REGION)"
else
remote:
	 $(error No BUCKET_NAME given)
endif
