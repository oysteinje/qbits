#!/bin/sh

# Update package sources
sudo apt-get update

# Install nodejs 
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install nginx 
sudo apt-get install -y nginx

# Configure nginx webserver 
cd /var/www
sudo mkdir main
cd main
sudo curl https://raw.githubusercontent.com/oysteinje/qbits/main/index.html -o index.html
cd /etc/nginx/sites-enabled
sudo curl  -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/oysteinje/qbits/main/vhost -o vhost

# Restart to apply changes 
sudo service nginx restart

