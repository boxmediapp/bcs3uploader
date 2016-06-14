#!/usr/bin/env python
import base64
import getopt
import httplib
import json
import re
import os
import sys
import StringIO
import urlparse
import xml.dom.minidom
import zipfile
import httplib
import json


bc_config_filepath=os.path.expanduser("~") + "/.bcs3uploader/credentials"
scriptbasedir=os.path.dirname(os.path.realpath(__file__))
bc_oauth_url="https://oauth.brightcove.com/v3"
bc_cms_url="https://cms.api.brightcove.com/v1"
bc_ingest_url="https://cms.api.brightcove.com/v1"
template_file_for_create_video=scriptbasedir+"/template-create-video.json"
template_file_for_ingest_video=scriptbasedir+"/template-ingest-video.json"
bcuploader_logfile="/tmp/bcuploader_logfile.log"




def createBCConfigDir():
  os.makedirs(os.path.expanduser("~") + "/.bcs3uploader")

def loadConfig():
  config = {}
  f = open(bc_config_filepath, "r")    
  for line in f:
        line = line.strip("\n")
        i = line.index("=")
        varibleName = line[:i]
        varibleValue = line[i+1:]
        config[varibleName] = varibleValue
  return config

def isBCConfigured():
  return os.path.exists(bc_config_filepath)

def saveConfig(config):  
  f = open(bc_config_filepath, "w")    
  for key, value in config.items():
    f.write(key + "=" + value + "\n")
  f.close()  

def log(messsage):
  f = open(bcuploader_logfile, "a")
  f.write(messsage+"\n")

def requestToken(config):
    headers = dict()
    headers['Authorization'] = 'Basic %s' % base64.b64encode(config["bc_access_key_id"]+":"+config["bc_secret_access_key"])  
    headers["Content-Type"]="application/x-www-form-urlencoded"              
    conn = httplib.HTTPSConnection('oauth.brightcove.com')           
    conn.request('POST', "/v3/access_token", "grant_type=client_credentials", headers)
    resp=conn.getresponse()
    responseInJson = json.load(resp)
    return responseInJson["access_token"]
    
  