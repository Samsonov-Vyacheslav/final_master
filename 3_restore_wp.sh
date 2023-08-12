#!/bin/sh

#Параметры  подключения к MySQL
MYSQL_USER='root' 
MYSQL_PASSWORD='!Ahhjntf0p02u1'
MYSQL_HOST='localhost'
MYSQL_PORT='3306'
BACKUP_DIRECTORY="/var/backup/wordpress"

mkdir -pm 777 $BACKUP_DIRECTORY

MYSQL=$"-u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P $MYSQL_PORT"

#Созздание базы
echo "CREATE DATABASE wordpress;" |  mysql $MYSQL 2>/dev/null 

#Создание пользователя
echo "CREATE USER root@localhost IDENTIFIED BY '$MYSQL_PASSWORD'; GRANT ALL PRIVILEGES ON wordpress.* TO root@localhost; FLUSH PRIVILEGES;" |  mysql $MYSQL

mkdir /var/backup

cp -rf /tmp/final_master/backup/wordpress /var/backup

TABLES=$(ls /var/backup/wordpress/)

echo $TABLES

#Восстановление базы из бэкапа
for TABLE in $TABLES; do
		gunzip < /var/backup/wordpress/$TABLE | mysql $MYSQL wordpress 2>/dev/null
done

echo "show databases;" |  mysql $MYSQL 2>/dev/null

