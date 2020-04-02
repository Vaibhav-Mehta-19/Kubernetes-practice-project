#!/bin/bash
trap "exit" SIGINT
while :
do
  echo $(date) Writing fortune to /var/htdocs/index.html
  fortune > /var/htdocs/index.html
  sleep 10
done