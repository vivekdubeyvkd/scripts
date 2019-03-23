function removeOldFilesExceptLatestNFiles(){
    if [ $# -ne 3 ]
    then
       echo " ++++++++++++++++ error +++++++++++++++"
       echo "Wrong parameters passed ...... exiting now, please run again with correct parameters ...."
       echo "<function> <root clean up dir> <file extension to be removed> <number of latest files to keep>"
       exit 1
    fi

    rootCleanupDir=$1;shift
    filePatternToBeCleanedUp=$1;shift
    keepLatestNFiles=$1
    totalMatchingFileCount=$(ls -lrt ${rootCleanupDir}/*${filePatternToBeCleanedUp} | wc -l )
    fileToBeRemoved=0
    
    if [ ${totalMatchingFileCount} -gt ${keepLatestNFiles} ]
    then
        fileToBeRemoved=$((${totalMatchingFileCount} - ${keepLatestNFiles}))
        echo "Files to be removed : ${fileToBeRemoved}" 
        ls -lrt ${rootCleanupDir}/*${fileExtensionToBeCleanedUp} | head -${fileToBeRemoved} | awk '{print $NF}' | while read line
        do
            echo "removing ${line}"
            # on first run please comment the below "rm -rf $line" command and see the files to be removed in the output , if you are satisfied with that, then only uncomment the "rm -rf $line" command
            rm -rf $line
        done 
    else
        echo "Files to be removed : ${fileToBeRemoved}" 
        echo "There are no older files to be removed"
        exit 0
    fi
}


rootCleanupDir="/tmp" # this is the root dir where clean needs to be done
fileExtensionToBeCleanedUp=".txt" # file pattern to be matched and removed
keepLatestNFiles=10

# calling this with defined parameters
removeOldFilesExceptLatestNFiles $rootCleanupDir $fileExtensionToBeCleanedUp $keepLatestNFiles

# it can be called as many times as we want with different set of parameters
removeOldFilesExceptLatestNFiles "/var/log" ".log" 20 
removeOldFilesExceptLatestNFiles "/tmp" ".tmp" 5 
