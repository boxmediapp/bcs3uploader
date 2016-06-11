# FOR PYTHON 3!!!!

import time
import os
config = {}
if not os.path.exists(os.path.expanduser("~") + "\.bcs3uploader\credentials"):
    os.makedirs(os.path.expanduser("~") + "\.bcs3uploader")
else:
    f = open(os.path.expanduser("~") + "\.bcs3uploader\credentials", "r")
    print("Credentials before: ")
    for line in f:
        line = line.strip("\n")
        i = line.index("=")
        varibleName = line[:i]
        varibleValue = line[i+1:]
        config[varibleName] = varibleValue
        print(line)
    print("-" * 20)
    print(config)

print("Type in the following...")
print("\n")

accountid = input("Brightcove API account id:")
if accountid != "":
    config["bc_account_id"] = accountid
key = input("Brightcove API access key: ")
if key != "":
    config["bc_access_key_id"] = key
secretkey = input("Brightcove API secret key: ")
if secretkey != "":
    config["bc_secret_access_key"] = secretkey
print(config)

f = open(os.path.expanduser("~") + "\.bcs3uploader\credentials", "w")
for key, value in config.items():
    f.write(key + "=" + value + "\n")
#f.write("bc_account_id=" + config["bc_account_id"] + "\nbc_access_key_id=" + config["bc_access_key_id"] + "\nbc_secret_access_key=" + config["bc_secret_access_key"])
f.close()
print("Finished.")
time.sleep(2)