
PASSOPTS=""
if [ -n "$NOPASS"  ]; then
export PASSOPTS=nopass
export EASYRSA_BATCH=true
fi

ssh -t -t -i ${key_path}  -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
     "${user}@${host_address}" \
    sudo docker run -v ovpn-data:/etc/openvpn -e EASYRSA_BATCH=$EASYRSA_BATCH \
        -e EASYRSA_REQ_CN=${ca_common_name}  \
        --rm -it   ${vpn_image} ovpn_initpki $PASSOPTS
