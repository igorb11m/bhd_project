#!/bin/bash
for i in {1..20}; do
  sudo docker exec rsyslog sh -c "echo '$(date) SERVER-AUTH: Failed password for root from 192.168.1.55 port 22' >> /var/log/remote/auth_attack.log"
done