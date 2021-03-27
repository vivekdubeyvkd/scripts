# run it as a root
# 55555 is port to be opened
# reference https://www.thegeekdiary.com/how-to-open-a-ports-in-centos-rhel-7/

# update config for new port to be opened
firewall-cmd --zone=public --add-port=55555/tcp --permanent

# reload new config
firewall-cmd --reload

