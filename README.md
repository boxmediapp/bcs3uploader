# bcs3uploader

This script is for uploading videos to the Brightcove Video Cloud (https://signin.brightcove.com).

It does the following: 

  - Create a place holder in the brightcove video cloud (inactive)
  - Trim 10 seconds from the beginning of the video(remove the clock)
  - Trim 10 seconds from the end of the the video 
  - Upload the video to the s3 bucket 
  - Initiates the Brightcove ingest process to ingest the video in the s3 bucket. 


This scripts uses the AWS Command Line Interface to upload the video to the S3 bucket, so you need to install it from the following link:

    http://docs.aws.amazon.com/cli/latest/userguide/installing.html

After the installation is completed, you need to configure it:

    aws configure

This will ask AWS key and secret that will be used to upload the video to the s3 bucket.

This script uses the FFmpeg utilities to trim the video, so you need to download and install FFmpeg from the following link:

    https://ffmpeg.org/download.html

Then, you can can download this repository

    git clone git@github.com:boxmediapp/bcs3uploader.git
    

then run the configuration script:

     bcs3uploader/config_bc.sh
   
this will ask account id, key and secrets that are going to be used to interact with the video cloud.

Then finally, you can run the script to upload the video to the brightcove video cloud:

    bcs3uploader/trim_upload.sh  <video file path>


If you would like to change/add the metadata for the video to be uploaded, you can edit the "template-create-video.json"

Note that I am re-implementing the functionalities in python script as well but it is not yet completed. 
   
   


