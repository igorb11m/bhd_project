#!/bin/bash
sudo docker exec rsyslog sh -c "echo '$(date) IOT-SENSOR-TEMP-01: Status=OK Temperature=23.5C Battery=85% Heartbeat' >> /var/log/remote/iot.log"