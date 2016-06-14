import os
import sys
import os.path
import ntpath
import time
import bcs3util
import datetime
import time

args=sys.argv[1:]
inputvideo_filepath=args[0]

timestamp=int(time.time())


inputvideo_basefilepath, inputvideo_extension = os.path.splitext(inputvideo_filepath)

inputvideo_filename=ntpath.basename(inputvideo_filepath)

inputvideo_filename_base, inputvideo_extension=os.path.splitext(inputvideo_filename)


inputvideo_trimmedfilepath='/tmp/'+inputvideo_basefilepath+'_'+str(timestamp)+"."+inputvideo_extension



inputvideo_title=inputvideo_filename_base

bcs3util.log("**************"+datetime.date.today().strftime("%I:%M%p on %B %d, %Y")+"******")

bcs3util.log("inputvideo_filepath:"+inputvideo_filepath);

bcs3util.log("inputvideo_extension:"+inputvideo_extension)
bcs3util.log("inputvideo_basefilepath:"+inputvideo_basefilepath)
bcs3util.log("inputvideo_trimmedfilepath:"+inputvideo_trimmedfilepath)
if bcs3util.isBCConfigured():
    config=bcs3util.loadConfig()
    bc_access_token= bcs3util.requestToken(config)
