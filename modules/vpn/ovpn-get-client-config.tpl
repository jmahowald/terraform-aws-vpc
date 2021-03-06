#!/bin/bash -x

username=$${1:-$$USER}

VPN_CONFIG_FILE=$${username}.ovpn

ssh -t  -i ${key_path} -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
       "${user}@${host}" \
     sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_getclient "$${username}" > $$VPN_CONFIG_FILE

#So this really means I should learn how to change the config from
#the open vpn server, but well I don't know how to.


sed -e '/redirect-gateway def1/ s/^#*/#/' -i bak $$VPN_CONFIG_FILE
echo "route ${vpc_netmask}  $vpn_gateway" >> $$VPN_CONFIG_FILE
