## reference https://docs.docker.com/install/linux/docker-ee/rhel/
## reference https://stackoverflow.com/questions/51479406/error-package-docker-ce-requires-container-selinux-2-9-centos-7
## reference https://www.cyberciti.biz/faq/install-use-setup-docker-on-rhel7-centos7-linux/

sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
                  
sudo yum install -y yum-utils device-mapper-persistent-data lvm2     
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ee docker-ee-cli containerd.io

## if above yum commands give error with selinux package something like container-selinux >= 2.9, then
## run below command first and then run "sudo yum -y install docker-ee docker-ee-cli containerd.io" again, hopefully this resolve the issue
sudo yum install ftp://bo.mirror.garr.it/1/slc/centos/7.1.1503/extras/x86_64/Packages/container-selinux-2.9-4.el7.noarch.rpm


                  
                  
