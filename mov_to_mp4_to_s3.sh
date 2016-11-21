#!/bin/bash
scriptbasedir=$(dirname "$0")

sourcevideo=$1
filename=$2
destfullpath=$3


cd /data


commandString='ffmpeg -i '$sourcevideo' -y -vcodec copy -af dynaudnorm=f=24:g=31:p=.70:m=20:r=1:n=1:c=1:b=0 -ar 48000 -ac 2 -acodec aac -ab 128k  -strict -2 '$filename
echo "Executing:: $commandString"
$commandString
 
commandString='aws s3 cp '$filename' '$destfullpath

echo "Executing:: $commandString"

$commandString

rm $filename
