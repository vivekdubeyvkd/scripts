// need to think a little bit as how it can be handled using only one flag variable , but tbis works
str = 'viVek2'
flagUpper = 0
flagLower = 0
flagDigit = 0
for(index = 0;index < str.size();index ++){ 
   if(str.charAt(index).isLowerCase()){
      flagLower = 1
   }else if(str.charAt(index).isUpperCase()){
      flagUpper = 1 
   }else if(str.charAt(index).isDigit()){
        flagDigit = 1
   } 
}  

if(flagUpper == 1 && flagLower == 1 && flagDigit == 1){
  println "string is fine"
}else{
  println "string is not fine"
}  
