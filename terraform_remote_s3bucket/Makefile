
terraform.tfplan: plan

plan: 
	terraform plan -out terraform.tfplan

apply: terraform.tfplan
	terraform apply 


destroy:
	terraform plan -destroy -out terraform.tfplan
	terraform destroy 

