#!/bin/bash
scriptbasedir=$(dirname "$0")

bucketname=$1
filepath=$2
filename=$3
destfolder=$4

file_extension="${filename##*.}"
base_filename="${filename%.*}"



cd /data
echo "executing::aws s3 cp s3://$bucketname/$filepath  $filename"

aws s3 cp s3://$bucketname/$filepath  $filename


convert(){

width=$1
height=$2


destfilename=$base_filename'_'$width'x'$height'.'$file_extension

commandString='ffmpeg -y -i '$filename' -vf scale='$width':'$height' '$destfilename
echo "Executing:: $commandString"
$commandString
 
commandString='aws s3 cp '$destfilename' s3://'$bucketname'/'$destfolder'/'$destfilename
echo "Executing:: $commandString"
$commandString
rm $destfilename
}


convert 320 180
convert 1920 1080
convert 288 162
convert 256 144

convert 400 225
convert 432 243
convert 512 288
convert 640 360
convert 786 406
convert 824 426
convert 1089 563
convert 1160 508
convert 1280 720


rm $filename







 





