#!/bin/bash
for port in {80,443,21,22,23,3306,8080,53}; do
  sudo docker exec rsyslog sh -c "echo '$(date) FIREWALL-LOG: IN=eth0 OUT= MAC=ff:ff SRC=10.0.0.66 DST=192.168.1.1 PROTO=TCP DPT=$port ACTION=DROP' >> /var/log/remote/firewall.log"
done