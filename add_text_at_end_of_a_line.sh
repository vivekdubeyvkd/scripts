# I have a file myfile.txt with content as shown below
# my name is vivek
# people call me vivek
# I love my name vivek
# Now I want to add ' dubey' at the end of each line in myfile.txt

export FILE_NAME=myfile.txt
sed -i "s/$/ dubey/g" ${FILE_NAME}

echo ""
cat ${FILE_NAME}
echo ""
