bc_config_filepath="$HOME/.bcs3uploader/credeantials"
if [ -f $bc_config_filepath ]; then
	. $bc_config_filepath	
else    
    mkdir "$HOME/.bcs3uploader"	   
fi


read -p "Brightcove API Account ID[$bc_account_id]:" bc_id
read -p "Brightcove API Access Key[$bc_access_key_id]:" bc_key
read -p "Brightcove API Access Secret[$bc_secret_access_key]:" bc_secret

if [ "$bc_id" == "" ]; then
   echo   
else
   bc_account_id=$bc_id
fi



if [ "$bc_key" == "" ]; then
   echo   
else
  bc_access_key_id=$bc_key
fi
 
if [ "$bc_secret" == "" ]; then
   echo 
else
  bc_secret_access_key=$bc_secret
fi

echo "bc_account_id=$bc_account_id" > $bc_config_filepath
echo "bc_access_key_id=$bc_access_key_id" >> $bc_config_filepath
echo "bc_secret_access_key=$bc_secret_access_key" >> $bc_config_filepath

