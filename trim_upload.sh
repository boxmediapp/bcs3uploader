#!/bin/bash
scriptbasedir=$(dirname "$0")

bc_oauth_url=https://oauth.brightcove.com/v3
bc_cms_url=https://cms.api.brightcove.com/v1
bc_ingest_url=https://cms.api.brightcove.com/v1


template_file_for_create_video="$scriptbasedir/template-create-video.json"
template_file_for_ingest_video="$scriptbasedir/template-ingest-video.json"
bc_config_filepath="$HOME/.bcs3uploader/credentials"

inputvideo_filepath=$1
inputvideo_extension="${inputvideo_filepath##*.}"
inputvideo_basefilepath="${inputvideo_filepath%.*}"
inputvideo_filename=${inputvideo_filepath##*/}
inputvideo_filename_base="${inputvideo_filename%.*}"
inputvideo_title=$inputvideo_filename_base
timestamp=$(date +%s)
bcuploader_logfile="/tmp/bcuploader_logfile.log"
now=`date`
inputvideo_trimmedfilepath='/tmp/'$inputvideo_basefilepath'_'$timestamp'.'$inputvideo_extension


log(){
	logContent=$1
    echo $1 >> $bcuploader_logfile
}
initLog(){
	if [ -d /tmp ]; then
  		echo 
	else
  		mkdir /tmp
	fi
	
	if [ -f $bcuploader_logfile ]; then  
        echo "***********$now*************" >> $bcuploader_logfile
	else
  		echo "***********$now*************" > $bcuploader_logfile
    fi
}
initLog

log "inputvideo_filepath:$inputvideo_filepath"
log "inputvideo_extension:$inputvideo_extension"
log "inputvideo_basefilepath:$inputvideo_basefilepath"
log "inputvideo_filename:$inputvideo_filename"
log "inputvideo_filename_base:$inputvideo_filename_base"
log "inputvideo_title:$inputvideo_title"
log "inputvideo_trimmedfilepath:$inputvideo_trimmedfilepath"


load_config(){
   . $bc_config_filepath
   log "loaded the config:account_id:$bc_account_id"
}


getvideoproperties(){
    video_property=$(ffprobe -i $inputvideo_filepath -show_format -v quiet)
    log "video property:$video_property"    
	bc_origin_video_duration=$(echo $video_property | sed 's/.*duration=//g' | sed 's/ .*//g' | sed 's/\..*//g')
    log "original video duration in seconds:$bc_origin_video_duration"
    bc_trimmed_video_duration=$((bc_origin_video_duration-20))
    log "trimmed  video duration:$bc_trimmed_video_duration"       
}



request_token(){
    bc_token_request_post_body="grant_type=client_credentials"
	token_request_command='curl -X POST --user "'$bc_access_key_id':'$bc_secret_access_key'" --data '$bc_token_request_post_body' '$bc_oauth_url'/access_token'
    
    token_response_body=$(eval $token_request_command)
    log "token_response_body:$token_response_body"
 
    bc_access_token=$(echo "$token_response_body" | sed 's/.*access_token\"\:\"//' |sed 's/\".*//')
}
create_video_placeholder(){
    create_video_request_body=`cat $template_file_for_create_video`	
	create_video_request_body=$(echo $create_video_request_body | sed "s/###ingest-video-title###/${inputvideo_title}/g")    
    create_video_request_tmpfile=$(mktemp '/tmp/create-video-'$inputvideo_filename_base'_'$timestamp'.json')
    
    log "video request tmp file:$create_video_request_tmpfile"    
    
    echo "$create_video_request_body" > $create_video_request_tmpfile
    log "create_video_request_body:$create_video_request_body"
               
    create_video_command="curl  -X POST -H \"Authorization: Bearer $bc_access_token\"    -d @$create_video_request_tmpfile      $bc_cms_url/accounts/$bc_account_id/videos"
        
    log "create_video_command:$create_video_command"
        
    create_video_response_body=$(eval $create_video_command)
    
    log "create_video_response_body:$create_video_response_body"    
        
    bc_video_id=$(echo "$create_video_response_body" | grep "\"id\"\s*:"| sed -e 's/.*\"id\" *\: *\"//' | sed 's/\".*//')
    
    log "bc_video_id:$bc_video_id"
}



trimvideo(){
if [ -f $inputvideo_filepath ]; then
   log "trmming video $inputvideo_filepath to $inputvideo_trimmedfilepath"
   ffmpeg     -ss 10  -i $inputvideo_filepath  -t $bc_trimmed_video_duration -codec copy $inputvideo_trimmedfilepath 
else
   echo "file does not exist:$inputvideo_filepath"
   log  "file does not exist:$inputvideo_filepath"
fi
}
s3uplad(){
if [ -f $inputvideo_trimmedfilepath ]; then
   log "Uploading the video to s3://box-video/$inputvideo_filename"
   aws s3 cp $inputvideo_trimmedfilepath s3://box-video/$inputvideo_filename
else
   echo "file does not exist:$inputvideo_trimmedfilepath"
   log  "file does not exist:$inputvideo_trimmedfilepath"
fi
   
}


ingest_video(){
if [ -f $inputvideo_trimmedfilepath ]; then
 if [ "$bc_access_token" == "" ]; then 
    echo "Skipping ingesting into brightcove"
 else   
    ingest_video_request_body=`cat $template_file_for_ingest_video`	    
	ingest_video_request_body=$(echo $ingest_video_request_body | sed "s/###video-file-name###/${inputvideo_filename}/g")    
    ingest_video_request_tmpfile=$(mktemp '/tmp/ingest-video-'$inputvideo_filename_base'-'$timestamp'.json')
    
    log "ingest request tmp file:$ingest_video_request_tmpfile"    
    
    echo "$ingest_video_request_body" > $ingest_video_request_tmpfile
    
    
    log "ingest_video_request_body:$ingest_video_request_body"
    echo "ingest:::::$ingest_video_request_tmpfile"           
    ingest_video_command="curl  -X POST -H \"Authorization: Bearer $bc_access_token\"    -d @$ingest_video_request_tmpfile      $bc_ingest_url/accounts/$bc_account_id/videos/$bc_video_id/ingest-requests"
        
    log "ingest_video_command:$ingest_video_command"
    echo $ingest_video_command    
    ingest_video_response_body=$(eval $ingest_video_command)        
    
    log "ingest_video_response_body:$ingest_video_response_body"
    
    echo $ingest_video_response_body
 fi  
 else
 echo "skipping the ingest because the source file does not exist:$inputvideo_trimmedfilepath"
 log "skipping the ingest because the source file does not exist:$inputvideo_trimmedfilepath"
 fi  
}



if [ -f $bc_config_filepath ]; then	
	load_config
	request_token
	create_video_placeholder
    	
else   
    echo "******************Warning**********" 
    echo "The brightcove configuration is not found, so will not ingest the video file into the brightcove video cloud."
    echo "But will try to upload the video file to the s3 bucket"
    echo "Please obtain the brightcove video cloud api key and secret from the brightcove video cloud studio, and then run the following command:"
    echo "./config_bc.sh"	   
    echo "******************Warning**********"
    log "The brightcove configuration is not found, skipping brightcove process"
fi

getvideoproperties
trimvideo
s3uplad
ingest_video



 





  



