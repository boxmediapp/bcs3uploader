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

bc_config_filepath=os.path.expanduser("~") + "/.bcs3uploader/credentials"

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

