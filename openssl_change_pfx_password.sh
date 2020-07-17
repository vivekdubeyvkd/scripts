openssl pkcs12 -in my.pfx -out tmpcert.pem -nodes
mv my.pfx my.pfx.old
openssl pkcs12 -export -out my.pfx -in tmpcert.pem
