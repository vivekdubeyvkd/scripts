# create 100 empty files as 1.txt ..... 100.txt

filePrefix=".txt"

# using for loop
for i in {1..100}
do
  touch ${i}.${filePrefix}
done

# using while loop
n=1
while [ $n -le 100 ]
do
  touch ${i}.${filePrefix}
  n=`expr $n + 1`
done

# just using touch and sequence
touch {1..100}${filePrefix}
