
KEY_NAME ?= $(TF_VAR_key_name)
KEY_DIR ?= $(TF_VAR_key_dir)



keys: $(TF_VAR_key_dir)/$(KEY_NAME).pub

$(KEY_DIR)/$(KEY_NAME).pem:
	mkdir -p $(KEY_DIR)
	openssl genrsa -out $(KEY_DIR)/$(KEY_NAME).pem 1024
	chmod 600 $(KEY_DIR)/$(KEY_NAME).pem

$(KEY_DIR)/$(KEY_NAME).pub: $(KEY_DIR)/$(KEY_NAME).pem
	ssh-keygen -y -f $(KEY_DIR)/$(KEY_NAME).pem > $(KEY_DIR)/$(KEY_NAME).pub
