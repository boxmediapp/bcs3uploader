getProjectVersionFromPom(){
  projectversion=`grep -A 0 -B 2 "<packaging>" pom.xml  | grep version  | cut -d\> -f 2 | cut -d\< -f 1`
  export projectversion  
}

buildVariables(){
  export zipfilename="bcs3uploader-$projectversion.zip"
  export sourcezipfilepath="package/target/$zipfilename"
  export destzipfilepath="bcs3uploader/$zipfilename"   
}

  
executeScriptOnServer(){
   echo "executing the script $1 remotely  on  $deploy_to_username@$deploy_to_hostname "
   ssh $deploy_to_username@$deploy_to_hostname 'bash -s' < $1      
   echo "remote execution completed"   
}
  
  createBcs3uploaderDirectoryOnServer(){
    uniqueidforfilename=$(date +%s)
    echo "creating the script for creating folder: /tmp/script_$uniqueidforfilename.sh"   
    echo "mkdir -p bcs3uploader" > /tmp/script_$uniqueidforfilename.sh    
    executeScriptOnServer /tmp/script_$uniqueidforfilename.sh
}

uploadZipFile(){     
    echo "uploading the $sourcezipfilepath to  $deploy_to_username@$deploy_to_hostname:$destzipfilepath"
    scp $sourcezipfilepath $deploy_to_username@$deploy_to_hostname:$destzipfilepath
}


unzipZipFile(){    
      uniqueidforfilename=$(date +%s)
      echo "creating the install script:/tmp/script_$uniqueidforfilename.sh"
      echo "cd bcs3uploader" > /tmp/script_$uniqueidforfilename.sh
      echo "unzip -o $zipfilename" >> /tmp/script_$uniqueidforfilename.sh    
    
     executeScriptOnServer /tmp/script_$uniqueidforfilename.sh
}

  