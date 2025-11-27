#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

echo ">>> Uruchomiono PEŁNY SYMULATOR (HTTP + SSH + IoT)..."
echo ">>> Rozkład: HTTP 200 (60%), 404 (15%), 301 (10%), 500 (5%), SSH (5%), IoT (5%)"
echo ">>> Naciśnij CTRL+C, aby zatrzymać."

PATHS_200=("/" "/index.html" "/contact" "/about-us" "/api/v1/products" "/images/logo.png" "/css/style.css")
PATHS_404=("/old-page.html" "/admin/config" "/secret.txt" "/wp-login.php" "/test")
PATHS_301=("/home" "/start" "/pl")
SITE_USERS=("admin" "root" "igor" "milosz" "support" "oracle" "test")
IPS=("192.168.1.50" "192.168.1.51" "10.0.0.5" "8.8.8.8" "172.16.0.22" "45.33.22.11")
UAS=("Mozilla/5.0 (Windows NT 10.0)" "Mozilla/5.0 (iPhone)" "Googlebot/2.1")

while true; do
  CHANCE=$((1 + $RANDOM % 100))
  
  IP=${IPS[$RANDOM % ${#IPS[@]}]}
  UA=${UAS[$RANDOM % ${#UAS[@]}]}
  SITE_USER=${SITE_USERS[$RANDOM % ${#SITE_USERS[@]}]}
  PORT=$((10000 + $RANDOM % 50000))


  if [ $CHANCE -le 5 ]; then
     TEMP=$((20 + $RANDOM % 10))
     sudo docker exec rsyslog sh -c "echo '$(date) IOT-SENSOR-01: Status=OK Temp=${TEMP}C Battery=85% Heartbeat' >> /var/log/remote/iot.log"


  elif [ $CHANCE -le 10 ]; then
     sudo docker exec rsyslog sh -c "echo '$(date) SERVER-SSH: Failed password for invalid user $SITE_USER from $IP port $PORT ssh2' >> /var/log/remote/auth.log"

  elif [ $CHANCE -le 70 ]; then
     URL_PATH=${PATHS_200[$RANDOM % ${#PATHS_200[@]}]}
     sudo docker exec rsyslog sh -c "echo '$(date) NGINX-ACCESS: $IP - - \"GET $URL_PATH HTTP/1.1\" 200 $((500 + $RANDOM % 5000)) \"-\" \"$UA\"' >> /var/log/remote/webapp.log"
  
  elif [ $CHANCE -le 85 ]; then
     URL_PATH=${PATHS_404[$RANDOM % ${#PATHS_404[@]}]}
     sudo docker exec rsyslog sh -c "echo '$(date) NGINX-ACCESS: $IP - - \"GET $URL_PATH HTTP/1.1\" 404 124 \"-\" \"$UA\"' >> /var/log/remote/webapp.log"
  
  elif [ $CHANCE -le 95 ]; then
     URL_PATH=${PATHS_301[$RANDOM % ${#PATHS_301[@]}]}
     sudo docker exec rsyslog sh -c "echo '$(date) NGINX-ACCESS: $IP - - \"GET $URL_PATH HTTP/1.1\" 301 0 \"-\" \"$UA\"' >> /var/log/remote/webapp.log"
  
  else
     sudo docker exec rsyslog sh -c "echo '$(date) NGINX-ACCESS: $IP - - \"GET /api/checkout HTTP/1.1\" 500 540 \"-\" \"$UA\"' >> /var/log/remote/webapp.log"
  fi

  sleep $(awk -v min=0.2 -v max=1.5 'BEGIN{srand(); print min+rand()*(max-min)}')
done
EOF