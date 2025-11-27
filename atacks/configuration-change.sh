#!/bin/bash
sudo docker exec rsyslog sh -c "echo \"$(date) CORE-ROUTER: %SYS-5-CONFIG_I: Configuration modified by user 'unknown' via console\" >> /var/log/remote/network.log"