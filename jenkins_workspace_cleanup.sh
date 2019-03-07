## check run user : It must be "<username>"
## to be run on any concerned Jenkins slaves
if [ "$(id -un)" != "<username>" ]
then
  echo " ++++++++++++++  ERROR ++++++++++++++++++"
  echo " Permission denied !! Only <username> user can run this script !! "
  echo " Kindly try again to run this script as <username> user !! Have a good day :) "
  echo " ++++++++++++++  ERROR ++++++++++++++++++"
  exit 1
fi

function list_remove_older_dir(){
    lookUpPath=$1
    if [ -d $lookUpPath ]
    then
        # you can modify below find command as per your requirement and build setup etc
        find ${lookUpPath} ! -path "*/*/*/*/*" -mtime +1 -type d | while read dir
        do
           echo "removing $dir"
           rm -rf $dir
        done
    else
       echo "no such path $lookUpPath found on $hostname machine"
    fi   
}

list_remove_older_dir "<path1>"
list_remove_older_dir "<path2>"
