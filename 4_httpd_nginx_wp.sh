#!/bin/sh

#Установка требуемых пакетов
yum install -y mc nano epel-release wget yum-utils

#Установка и старт apache nginx
yum install -y nginx httpd

systemctl enable --now nginx
systemctl enable --now httpd

#Установка PHP
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php74
yum install -y php php-mysqli php-xml

#Установка Wordpress
cd /tmp
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
mkdir -p /var/www/html
mkdir -p /var/www/html1
mkdir -p /var/www/html2
rsync -avP ./wordpress/ /var/www/html/
rsync -avP ./wordpress/ /var/www/html1/
rsync -avP ./wordpress/ /var/www/html2/
mkdir -p /var/www/html/wp-content/uploads
mkdir -p /var/www/html1/wp-content/uploads
mkdir -p /var/www/html2/wp-content/uploads
sudo chown -R apache:apache /var/www/html/*
sudo chown -R apache:apache /var/www/html1/*
sudo chown -R apache:apache /var/www/html2/*
cd /tmp/final_master/www/html
cp -rf ./wp-config.php /var/www/html/wp-config.php
cd /tmp/final_master/www/html1
cp -rf ./wp-config.php /var/www/html1/wp-config.php
cd /tmp/final_master/www/html2
cp -rf ./wp-config.php /var/www/html2/wp-config.php

#Клпирование конфигов nginx apache
cd /tmp/final_master/
cp -rf ./httpd/* /etc/httpd
cp -rf ./nginx/* /etc/nginx

#Перезапуск служб
systemctl restart httpd
echo "httpd"
systemctl is-active httpd

systemctl restart nginx
echo "nginx"
systemctl is-active nginx

#Порты
ss -tlpn

#Применение конфигов
nginx -s reload
httpd -t

