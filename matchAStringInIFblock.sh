function stringMatch(){
    str=$1
    if [[ $str =~ $matchText ]]
    then
       echo "YES"
    else
       echo "NO"
    fi
}


export matchText="Vivek"
export testString="Vivek is a good boy"
# outcome is YES if testString contains the word in matchText variable, else it will return NO

stringMatch "${testString}"
# it should return YES

matchText="vicky"
stringMatch "${testString}"
# this should return NO
