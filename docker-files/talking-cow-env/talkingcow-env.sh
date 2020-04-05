#!/bin/bash
trap "exit" SIGINT
echo Demonstrating passing environemental variables
echo Configured to generate new fortune every $INTERVAL seconds
while  :
do
  echo $(date) Writing fortune after an interval of $INTERVAL seconds
  fortune
  sleep $INTERVAL
done