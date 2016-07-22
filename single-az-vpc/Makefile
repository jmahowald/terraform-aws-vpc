
all: apply

TF_FILES=$(wildcard *.tf)
TF_VAR_ARGS ?=
# Passed in as an argument.
BUCKET_STATE ?=


#When we enable remote state on a terraform project,the
#.tfstate file goles
VPC_REMOTE_STATE_FILE=single-az-vpc/.terraform/terraform.tfstate


.terraform: $(TF_FILES)
	terraform get --update
	for i in $$(ls .terraform/modules/*/Makefile); do i=$$(dirname $$i); echo "Trying make in $$i"; make -C $$i; done


plan: terraform.tfplan
	
terraform.tfplan: $(TF_FILES) .terraform
	terraform plan -out terraform.tfplan $(TF_VAR_ARGS)

apply: terraform.tfplan
	terraform apply terraform.tfplan


clean: destroy
	rm -rf .terraform

destroy:
	terraform plan -destroy -out terraform.tfplan $(TF_VAR_ARGS)
	terraform destroy

#TODO: Use a single interface to clean

test:
	echo $(TF_VAR_ARGS)

$(VPC_REMOTE_STATE_FILE):


remote: $(VPC_REMOTE_STATE_FILE)
	 terraform remote config -backend=s3 \
	 -backend-config="bucket=$(shell terraform output --state=$(BUCKET_STATE) name)" \
	 -backend-config="key=$(shell terraform output aws_region)/vpc/terraform.tfstate" \
	 -backend-config="region=$(shell terraform output --state=$(BUCKET_STATE) bucket_region)"
