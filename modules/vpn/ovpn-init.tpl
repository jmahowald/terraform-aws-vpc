ssh -t -i ${key_path}  -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
     "${user}@${host}" \
     ${init_command}
