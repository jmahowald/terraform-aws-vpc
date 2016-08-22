#!/bin/sh
eval $(ssh-agent)
ssh-add $(terraform output key_file)

ssh -t -A  \
  -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
     $(terraform output bastion_user_2)@$(terraform output bastion_ip_2) ssh \
     -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
     $(terraform output image_user)@$(terraform output test_ip_2) 
