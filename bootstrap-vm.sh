#!/bin/sh

# Update package sources
sudo apt-get update

# Install gnupg
sudo apt-get install -y gnupg

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

# Install certbot 
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx --agree-tos -m oyststra@gmail.com -d main.azure.qbits.no -n

# Add automatic renewal of the certificate 
SLEEPTIME=$(awk 'BEGIN{srand(); print int(rand()*(3600+1))}'); echo "0 0,12 * * * root sleep $SLEEPTIME && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null

# Install mongodb
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Install firebase CLI
curl -sL https://firebase.tools | bash