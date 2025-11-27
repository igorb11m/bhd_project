#!/bin/bash
sudo docker exec rsyslog sh -c "echo '$(date) AUTH: session opened for user root by (uid=0)' >> /var/log/remote/auth.log"
sudo docker exec rsyslog sh -c "echo '$(date) SUDO: igor : TTY=pts/0 ; PWD=/home/igor ; USER=root ; COMMAND=/bin/bash' >> /var/log/remote/auth.log"