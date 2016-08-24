#!/bin/sh
eval $(ssh-agent)
ssh-add $(terraform output key_file)

# Connect to first instance through bastion, make sure that
# file that was suppoosed to be placed during test has correct contents
(ssh -t -A  \
  -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
     $(terraform output bastion_user)@$(terraform output bastion_ip_0) ssh \
     -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
     $(terraform output image_user)@$(terraform output test_ip_0) \
      cat test.txt | grep "hello world" \
     && echo "Connected to first instance") || echo "didn't get expected output output"

 # Connect to second instance through bastion, make sure that
 # file that was suppoosed to be placed during test has correct contents

 (ssh -t -A  \
   -o UserKnownHostsFile=/dev/null \
     -o StrictHostKeyChecking=no \
      $(terraform output bastion_user)@$(terraform output bastion_ip_1) ssh \
      -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
      $(terraform output image_user)@$(terraform output test_ip_1) \
       cat test.txt | grep "hello world" \
      && echo "Connected to SECOND instance") || echo "didn't get expected output output"


 # # Connect to second instance through
 # # first instance through second bastion, make sure that
 # # file that was suppoosed to be placed during test has correct contents
 (ssh -t -A  \
   -o UserKnownHostsFile=/dev/null \
     -o StrictHostKeyChecking=no \
      $(terraform output bastion_user)@$(terraform output bastion_ip_1) ssh \
      -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -t -A \
      $(terraform output image_user)@$(terraform output test_ip_0) \
      ssh -t -A  \
        -o UserKnownHostsFile=/dev/null \
          -o StrictHostKeyChecking=no \
      $(terraform output image_user)@$(terraform output test_ip_1) \
       cat test.txt \
      && echo "Connected through all the hoops") || echo "didn't get expected output on second"
