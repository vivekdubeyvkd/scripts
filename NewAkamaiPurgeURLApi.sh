# setup ~/.edgerc file,you can get/generate the content using Luna Control Portal and copy those into ~/.edgerc file
# ~/.edgerc file will look like as shown below(without # )
   # [ccu]
   # client_secret = *****
   # host = ****
   # access_token = ****
   # client_token = ******
   
# then issue command as shown below to purge a URL
akamai purge invalidate [URL1] [URL2] .... [URLn]
