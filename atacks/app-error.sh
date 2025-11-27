#!/bin/bash
for i in {1..30}; do
  sudo docker exec rsyslog sh -c "echo '$(date) WEB-APP: [ERROR] 500 Internal Server Error - DB Connection Failed' >> /var/log/remote/webapp.log"
done