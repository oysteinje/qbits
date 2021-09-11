#!/bin/sh
sudo apt-get update
sudo apt-get install -y nginx
cd /var/www
sudo mkdir main
cd main
curl https://raw.githubusercontent.com/oysteinje/qbits/main/index.html -o index.html
cd /etc/nginx/sites-enabled
curl https://raw.githubusercontent.com/oysteinje/qbits/main/vhost -o vhost
sudo service nginx restart