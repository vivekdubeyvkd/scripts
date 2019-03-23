function fib(){
   terms=$1
   first=1
   second=0
   echo $first 
   echo $second
   for i in $(seq $first $terms)
   do
      next=$(($first + $second))
      first=$second
      second=$next
      echo $next
   done
}

fib 30
