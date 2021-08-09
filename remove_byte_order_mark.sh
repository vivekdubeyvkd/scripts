# this script shows how to remove byte order mark in the form of chars like ï»¿
# for example my file name if myfile.txt with line having content as 
# ï»¿my name is vivek
# I want to remove ï»¿ from above line in myfile.txt

export FILE_NAME=myfile.txt
sed -i '1 s/^\xef\xbb\xbf//' ${FILE_NAME}

echo ""
cat ${FILE_NAME}
echo ""
