#!/bin/bash
trap "exit" SIGINT
INTERVAL=$1
echo Configured to generate new fortune every $INTERVAL seconds
while :
do
  echo $(date) Writing fortune to /var/htdocs/index.html
  fortune > /var/htdocs/index.html
  sleep $INTERVAL
done