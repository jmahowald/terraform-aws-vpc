all: apply

TF_FILES=$(wildcard *.tf)
TF_VAR_ARGS ?=

.terraform: $(TF_FILES)
	terraform get --update
	for i in $$(ls .terraform/modules/*/Makefile); do i=$$(dirname $$i); echo "Trying make in $$i"; make -C $$i; done

terraform.tfplan: plan

plan: .terraform
	terraform plan -out terraform.tfplan $(TF_VAR_ARGS)

apply: terraform.tfplan
	terraform apply terraform.tfplan


destroy:
	terraform plan -destroy -out terraform.tfplan $(TF_VAR_ARGS)
	terraform destroy

#TODO: Use a single interface to clean
