#!/bin/bash
scriptbasedir=$(dirname "$0")

bucketname=$1
filepath=$2
filename=$3

cd /data
aws s3 cp s3://bucketname/$filepath  $filename

