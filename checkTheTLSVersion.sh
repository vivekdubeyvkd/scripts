## use your hostname and port on which you want to check the acceptance of TLS requests
openssl s_client -connect <hostname>:<port> -tls1
openssl s_client -connect <hostname>:<port>  -tls1_1
openssl s_client -connect <hostname>:<port> -tls1_2
