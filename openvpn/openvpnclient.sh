#!/bin/bash

#sudo cp /path/to/vpn.crt /some/path/vpn-ca.crt
sudo docker run --net host -it --cap-add=NET_ADMIN --device /dev/net/tun:/dev/net/tun \
   -v /tmp/client.ovpn:/vpn/client.ovpn openvpn openvpn --dev /dev/net/tun  \
   --config /vpn/client.ovpn
