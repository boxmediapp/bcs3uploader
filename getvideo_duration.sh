#!/bin/bash
scriptbasedir=$(dirname "$0")

videourl=$1

ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$videourl"


