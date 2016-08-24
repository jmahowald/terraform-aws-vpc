#!/bin/sh
eval $(ssh-agent)
ssh-add $(terraform output key_file)


(ssh -t -A  \
  -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
     $(terraform output bastion_user)@$(terraform output bastion_ip_1) ssh \
     -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
     $(terraform output image_user)@$(terraform output test_ip_1) cat test.txt \
     grep "helo" \
     && echo "Connected to first instance") || echo "didn't get expected output output"
