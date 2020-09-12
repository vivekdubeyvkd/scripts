patterntoSearch="anything"
subFolderLevel=.../...

# look for pattern match only in specific kind of file, suppose say in all .java files under repo(s)
for dir in $(p4 dirs //depot/*); do
   p4 grep -n -e "${patterntoSearch}" $dir/${subFolderLevel}/*.java
done

# look for pattern match in all files under repo(s)
for dir in $(p4 dirs //depot/*); do
   p4 grep -n -e "${patterntoSearch}" $dir/${subFolderLevel}/...
done
