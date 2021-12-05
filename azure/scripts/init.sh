sudo apt update
wget https://git.io/vpn -O openvpn-install.sh
chmod +x openvpn-install.sh
sudo ./openvpn-install.sh 
sudo systemctl start openvpn-server@server.service

# Client installation 
# scp oystein@openvpn-qbits.norwayeast.cloudapp.azure.com:~/config.ovpn .
# sudo cp config.ovpn /etc/openvpn/client.conf
# sudo openvpn --client --config /etc/openvpn/client.conf
# sudo systemctl start openvpn@client 
