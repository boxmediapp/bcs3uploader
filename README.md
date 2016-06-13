# bcs3uploader

This script is for uploading videos to the Brightcove Video Cloud (https://signin.brightcove.com).

It does the following:
   (1) Create a place holder in the brightcove video cloud
   (1) Trim 10 seconds from the beginning of the video(remove the clock)
   (2) Trim 10 seconds from the end of the the video
   (3) Upload the video to the s3 bucket
   (4) Initiates the Brightcove ingest process to ingest the video in the s3 bucket.
   
This scripts uses the AWS Command Line Interface to upload the video to the S3 bucket, so you need to install it from the following link:

    http://docs.aws.amazon.com/cli/latest/userguide/installing.html

After the installation is completed, you need to configure it:

    aws configure

This will ask AWS key and secret that will be used to upload the video to the s3 bucket.

This script uses the FFmpeg utilities to trim the video, so you need to download and install FFmpeg from the following link:

    https://ffmpeg.org/download.html

Then, you can can download this script:


