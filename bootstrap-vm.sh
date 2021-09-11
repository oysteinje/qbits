#!/bin/sh
sudo apt-get update
sudo apt-get install -y nginx
cd /var/www
sudo mkdir main
cd main
sudo curl https://raw.githubusercontent.com/oysteinje/qbits/main/index.html -o index.html
cd /etc/nginx/sites-enabled
sudo curl  -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/oysteinje/qbits/main/vhost -o vhost
sudo service nginx restart