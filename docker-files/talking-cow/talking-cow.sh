#!/bin/bash
trap "exit" SIGINT
while :
do
  echo $(date) Talking cow:: 
  /usr/games/fortune > /var/htdocs/index.html
  sleep 10
done