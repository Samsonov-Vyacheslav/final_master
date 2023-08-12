#!/bin/sh

PASSWORD='!Ahhjntf0p02u1'
PASSWORD_SLAVE='!Ahhjntf0p02u1'

#Установка и запуск MySQL 8.0
rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-7.noarch.rpm
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
yum --enablerepo=mysql80-community install -y mysql-community-server
systemctl enable --now mysqld

#Временный пароль
pass=$(grep "A temporary password" /var/log/mysqld.log | awk '{print $NF}')

echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY '$PASSWORD'; FLUSH PRIVILEGES;" | mysql --connect-expired-password -uroot -p$pass

echo "CREATE USER 'root'@'%' IDENTIFIED BY '$PASSWORD'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;" |  mysql -uroot -p$PASSWORD

echo "SHOW MASTER STATUS;" |  mysql -uroot -p$PASSWORD

