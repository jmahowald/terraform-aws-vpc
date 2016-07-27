all: plan apply


export TF_VAR_bucket_region ?=$(BUCKET_REGION)
export TF_VAR_bucket_name ?=$(BUCKET_NAME)
export TF_VAR_bucket_key ?=$(BUCKET_KEY)

TF_FILES=$(wildcard *.tf)

.terraform: $(TF_FILES)
	terraform get --update




plan: $(TF_FILES) .terraform
	echo "Bucket key is $(BUCKET_KEY)+ $(TF_VAR_bucket_key) name r $(BUCKET_NAME)"
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
