#! /bin/bash

COUNT=2
EMAIL=os155greenteam@gmail.com

function healthcheck {
    ping=$(ping -c $1 $2 | grep 'received' | awk -F ',' '{print$2}' | awk '{print$1}')
}

while read server
do
    echo checking $server health...
    healthcheck $COUNT $server
    if [ $ping -eq 0 ]
    then
      echo "$server is DOWN"
      echo $(date), $server >> notify.tmp
      echo # breathing space
    else
      echo "$server is UP"
      echo # breathing space
    fi
done < servers.list


echo "Sending a notification to $EMAIL. Please wait..."
ssmtp $EMAIL < notify.tmp
echo "Notification Sent"


# resetting notify.tmp

echo "To: $EMAIL" > notify.tmp
echo "From: $EMAIL" >> notify.tmp
echo "Subject: Server Health" >> notify.tmp
echo " " >> notify.tmp
echo "Server Downs" >> notify.tmp


