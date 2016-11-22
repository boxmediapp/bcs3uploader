#!/bin/bash
scriptbasedir=$(dirname "$0")
sourcevideo=$1
destfullpath=$2
cd /data
commandString='aws s3 cp '$sourcevideo' '$destfullpath 
echo "Executing:: $commandString"
$commandString >transfer.log
rm $sourcevideo
