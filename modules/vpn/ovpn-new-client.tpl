
username=$${1:-$$USER}

ssh -t -i ${key_path} -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    "${user}@${host}"  \
     sudo docker run --volumes-from ovpn-data --rm -it gosuri/openvpn easyrsa build-client-full "$${username}" nopass
