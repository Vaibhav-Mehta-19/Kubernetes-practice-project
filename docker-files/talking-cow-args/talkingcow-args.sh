#!/bin/bash
trap "exit" SIGINT
INTERVAL=$1
echo Configured to generate new fortune every $INTERVAL seconds
while  :
do
  echo $(date) Writing fortune after an interval of $INTERVAL seconds
  fortune
  sleep $INTERVAL
done