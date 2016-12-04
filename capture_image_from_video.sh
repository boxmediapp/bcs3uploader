#!/bin/bash
scriptbasedir=$(dirname "$0")

videourl=$1

ffmpeg -ss $2 -i "$videourl"  -vframes 1 $3   


