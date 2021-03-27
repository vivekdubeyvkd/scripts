#!/bin/bash
# Author: Vivek Dubey(vivekdubeyvkd@gmail.com)
# to be run as root
# can install Git , Maven , Java , Tomcat and Jenkins
# needs the URL to download tools in .tar.gz format to complete the installation

if [  "$(id -un)" != "root" ]
then
  echo " ++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo " Please run this script as root user ..... exiting ......"
  echo " ++++++++++++++++++++++++++++++++++++++++++++++++++"
  exit 1
fi

export ROOT_INSTALL_DIR="/opt/tools"

if [[ -z ${ROOT_INSTALL_DIR} ]]
then
     ROOT_INSTALL_DIR=$(pwd)
fi


function install_tool(){
    export tool_download_url=$1
    export TOOL_BINARY_DOWNLOAD_DIR="${ROOT_INSTALL_DIR}"
    export TOOL_DOWNLOADED_FILE=$(basename "${tool_download_url}")
    export TOOL_DIR=${ROOT_INSTALL_DIR}/$(echo ${TOOL_DOWNLOADED_FILE} | cut -d'.' -f1)
    export OPTIONS=-k

    if [[ ${tool_download_url} =~ 'jenkins' ]]
    then
        export JAVA_HOME=${ROOT_INSTALL_DIR}/jdk
        export CATALINA_HOME=${ROOT_INSTALL_DIR}/tomcat
        (cd ${CATALINA_HOME}/webapps && \
           rm -rf ${TOOL_DOWNLOADED_FILE} && \
           curl  $OPTIONS -O "${tool_download_url}" && \
           chown <username>:<groupname> ${TOOL_DOWNLOADED_FILE} && \
           chmod 755 ${TOOL_DOWNLOADED_FILE}
        )
        echo "start tomcat ........"
        ${CATALINA_HOME}/bin/shutdown.sh 2>/dev/null && sudo -H -u <username> JAVA_HOME=${ROOT_INSTALL_DIR}/jdk ${CATALINA_HOME}/bin/startup.sh
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "check Jenkins instance on http://$(hostname -i):8080 ......."
        echo "Initial Admin login secret : $(sudo -H -u <username> cat $(eval echo ~${SUDO_USER})/.jenkins/secrets/initialAdminPassword) "
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        exit 0
    fi

    if [[ ${tool_download_url} =~ 'jdk' ]]
    then
          OPTIONS="${OPTIONS} -L -C - -b oraclelicense=accept-securebackup-cookie "
    fi

    if [[ -z ${TOOL_BINARY_DOWNLOAD_DIR} ]]
    then
        TOOL_BINARY_DOWNLOAD_DIR=$(pwd)
    fi

    # remove any existing installation
    rm -rf ${TOOL_DIR}
    rm -rf  ${TOOL_BINARY_DOWNLOAD_DIR}/${TOOL_DOWNLOADED_FILE}
    # download tool
    (  cd ${TOOL_BINARY_DOWNLOAD_DIR} && \
        curl $OPTIONS -O "${tool_download_url}"
    )

    if [ -f ${TOOL_BINARY_DOWNLOAD_DIR}/${TOOL_DOWNLOADED_FILE} ]
    then
        echo "tool file ${TOOL_BINARY_DOWNLOAD_DIR}/${TOOL_DOWNLOADED_FILE} downloaded successfully "
        ( mkdir -p ${TOOL_DIR} && \
            tar -xzf ${TOOL_BINARY_DOWNLOAD_DIR}/${TOOL_DOWNLOADED_FILE} --directory ${TOOL_DIR} && \
            cd  ${TOOL_DIR} && \
            dir_name=$(ls -rt ${TOOL_DIR})
            echo ${dir_name}
            cp -pr ${dir_name}/* .
            rm -rf ${dir_name}
        )

        if [[ ${tool_download_url} =~ 'git' ]]
        then
            (cd  ${TOOL_DIR} && \
                make configure && \
                ./configure  --prefix=${TOOL_DIR} && \
                make install
            )
        fi

       chown -R <username>:<groupname> ${TOOL_DIR}
       chmod -R 755 ${TOOL_DIR}
       if [[ ${tool_download_url} =~ 'jdk' ]]
       then
            echo "show java version ............ "
            rm -rf ${ROOT_INSTALL_DIR}/jdk
            ln -s ${TOOL_DIR} ${ROOT_INSTALL_DIR}/jdk
            chown -R  <username>:<groupname> ${ROOT_INSTALL_DIR}/jdk
            ${TOOL_DIR}/bin/java -version

       elif [[ ${tool_download_url} =~ 'git' ]]
       then
            echo "show git version "
             ${TOOL_DIR}/bin/git --version
       elif [[ ${tool_download_url} =~ 'maven' ]]
       then
            echo "show maven version ...."
            ${TOOL_DIR}/bin/mvn --version
       elif [[ ${tool_download_url} =~ 'tomcat' ]]
       then
            echo "show tomcat version ............... "
            #sed -i 's:8080:8081:g' ${TOOL_DIR}/conf/server.xml
            rm -rf ${ROOT_INSTALL_DIR}/tomcat
            ln -s ${TOOL_DIR} ${ROOT_INSTALL_DIR}/tomcat
            chown -R <username>:<groupname> ${ROOT_INSTALL_DIR}/tomcat
            ${TOOL_DIR}/bin/version.sh
       fi
    fi
}

if [ $# -gt 0 ]
then
  for arg in $@
  do
    echo "$arg"
    install_tool "$arg"
  done
else
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo " Invalid arguments passed .... exiting ....... "
  echo "<script> <tool_download_url1> <tool_download_url2> <tool_download_url3> <tool_download_url4> ......."
  echo "Note ::: download URL should be poiting to .tar.gz installer package ::"
  echo "Note :::: Jenkins URL should be passed after JAVA and TOMCAT download URL :::: "
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++"
  exit 2
fi
