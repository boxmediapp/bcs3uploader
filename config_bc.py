# FOR PYTHON 3!!!!

import time
import os
import bcs3util

config = {}
if not bcs3util.isBCConfigured():
    bcs3util.createBCConfigDir()
else:
    config=bcs3util.loadConfig()
       
accountid = raw_input("Brightcove API Account ID["+config["bc_account_id"]+"]:")

if accountid != "":
    config["bc_account_id"] = accountid


accesskey = raw_input("Brightcove API Access Key["+config["bc_access_key_id"]+"]:")

if accesskey != "":
    config["bc_access_key_id"] = accesskey



secretkey = raw_input("Brightcove API secret key["+config["bc_secret_access_key"]+"]:")
if secretkey != "":
    config["bc_secret_access_key"] = secretkey
if accountid != "" or accesskey != "" or secretkey != "":
    bcs3util.saveConfig(config)
