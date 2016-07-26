TF_FILES=$(wildcard *.tf)

all:apply

.terraform: $(TF_FILES)
	terraform get --update
	for i in $$(ls .terraform/modules/*/Makefile); do i=$$(dirname $$i); echo "Trying make in $$i"; make -C $$i; done


cleandeps:
	rm -rf .terraform

terraform.tfplan: plan


plan: .terraform
	terraform plan -out terraform.tfplan

apply: terraform.tfplan
	terraform apply 

