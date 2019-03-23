start=1
end=100

# using for loop
for i in $(seq $start $end)
do
  echo $i
done

# using while loop
while [ $start -le $end ]
do
  echo $start
  start=$(expr $start + 1)
done
