#!/bin/bash
scriptbasedir=$(dirname "$0")

bucketname=$1
filepath=$2
filename=$3
destfullpath=$4

file_extension="${filename##*.}"
base_filename="${filename%.*}"



cd /data
echo "executing::aws s3 cp s3://$bucketname/$filepath  $filename"

aws s3 cp s3://$bucketname/$filepath  $filename


convert(){


destfilename=$base_filename'.mp4'


#commandString='ffmpeg -i '$filename' -y -preset medium -r 25 -s 1024x576 -aspect 16:9 -vcodec libx264 -b:v 11M -profile:v high -level:v 3.1 -vf "yadif=0:-1:0" -af dynaudnorm=f=24:g=31:p=.70:m=20:r=1:n=1:c=1:b=0 -ar 48000 -ac 2 -acodec aac -ab 128k '$destfilename
commandString='ffmpeg -i '$filename' -y -vcodec copy -af dynaudnorm=f=24:g=31:p=.70:m=20:r=1:n=1:c=1:b=0 -ar 48000 -ac 2 -acodec aac -ab 128k  -strict -2 '$destfilename
echo "Executing:: $commandString"
$commandString
 
 


commandString='aws s3 cp '$destfilename' '$destfullpath

echo "Executing:: $commandString"

$commandString


rm $destfilename

}


convert

rm $filename

