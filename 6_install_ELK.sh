#!/bin/sh

#Установка Java
yum -y install java-openjdk-devel java-openjdk

#Установка  пакетов для ELK
cd  /tmp/rpm
rpm -i *.rpm

systemctl daemon-reload

rsync -arvuP /tmp/final_master/etc/elasticsearch/jvm.options.d/jvm.options /etc/elasticsearch/jvm.options.d/

rsync -arvuP /tmp/final_master/etc/kibana/kibana.yml /etc/kibana/

yes | cp -f /tmp/final_master/etc/logstash/logstash.yml /etc/logstash/logstash.yml

rsync -arvuP /tmp/final_master/etc/logstash/conf.d/logstash-nginx-es.conf /etc/logstash/conf.d/

rsync -arvuP /tmp/final_master/etc/filebeat/filebeat.yml /etc/filebeat/

#Установка прав на конфиг filebeat
chmod 600 /etc/filebeat/filebeat.yml
chown -R root:root /etc/filebeat/filebeat.yml

#Старт и автоззагрузка служб
systemctl enable --now elasticsearch.service
systemctl enable --now kibana
systemctl enable --now logstash
systemctl enable --now filebeat


#Проверка служб
echo "elasticsearch.service"
systemctl is-active elasticsearch.service

echo "kibana"
systemctl is-active kibana

echo "logstash"
systemctl is-active logstash

echo "filebeat"
systemctl is-active filebeat

echo "УСТАНОВКА ЗАВЕРШЕНА!"
