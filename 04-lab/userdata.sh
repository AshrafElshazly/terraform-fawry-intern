#!/bin/bash
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
sudo mkdir -p /var/www/html/
sudo touch /var/www/html/index.html
