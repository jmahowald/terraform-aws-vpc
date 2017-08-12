

if [ -n "$DOCKER_INSTALLED"  ]; then
    echo "Docker already setup"
else
    sudo yum install docker -y
    sudo service docker start
fi


sudo docker volume create --name ovpn-data
sudo docker run -v ovpn-data:/etc/openvpn --rm ${vpn_image} ovpn_genconfig -p ${vpn_cidr} -u udp://${host_address}
sudo docker run --restart always -v ovpn-data:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN ${vpn_image}
