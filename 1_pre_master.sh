#!/bin/sh

#Установка точного времени
timedatectl set-timezone Europe/Moscow

#Отключение SeLinux и firewalld
sudo sed -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config
echo "SeLinux disabled after reboot"
systemctl disable --now firewalld

#Установка имени системы
HOSTNAME=mysql-master
hostnamectl set-hostname $HOSTNAME
systemctl restart systemd-hostnamed

yum install -y sshpass

#Настройка статического IP
UUID=`cat /etc/sysconfig/network-scripts/ifcfg-e* | awk -F "=" '/UUID/ {print $2}'`
DEVICE=`cat /etc/sysconfig/network-scripts/ifcfg-e* | awk -F "=" '/DEVICE/ {print $2}' | sed 's/\"//g'`

echo "TYPE=\"Ethernet\"
PROXY_METHOD=\"none\"
BROWSER_ONLY=\"no\"
BOOTPROTO=\"static\"
IPADDR=192.168.1.36
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4
DEFROUTE=\"yes\"
IPV4_FAILURE_FATAL=\"no\"
IPV6INIT=\"yes\"
IPV6_AUTOCONF=\"yes\"
IPV6_DEFROUTE=\"yes\"
IPV6_FAILURE_FATAL=\"no\"
IPV6_ADDR_GEN_MODE=\"stable-privacy\"
NAME=\"$DEVICE\"
UUID=$UUID
DEVICE=\"$DEVICE\"
ONBOOT=\"yes\"
">/etc/sysconfig/network-scripts/ifcfg-$DEVICE

systemctl restart network

#Установка GIT
yum install -y git

#Перезагрузка
read -p "Reboot now (y/n)"

if [[ $REPLY =~ ^[Yy]$ ]]
then
    reboot
else
	exit 1
fi
