keys: $(TF_VAR_key_dir)/$(TV_VAR_key_name).pub

$(TF_VAR_key_dir)/$(TV_VAR_key_name).pem:
	mkdir -p $(TF_VAR_key_dir)
	openssl genrsa -out $(TF_VAR_key_dir)/$(TV_VAR_key_name).pem 1024
	chmod 600 $(TF_VAR_key_dir)/$(TV_VAR_key_name).pem

$(TF_VAR_key_dir)/$(TV_VAR_key_name).pub: $(TF_VAR_key_dir)/$(TV_VAR_key_name).pem
	ssh-keygen -y -f $(TF_VAR_key_dir)/$(TV_VAR_key_name).pem > $(TF_VAR_key_dir)/$(TV_VAR_key_name).pub
