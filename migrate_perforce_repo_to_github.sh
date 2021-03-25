#!/bin/bash

##
#  ************************************************************************************************************************
#  * Script Name : migrate_perforce_repo_to_github.sh
#  * Purpose : Sophisticated utility to quickly migrate Perforce repos to GitHub in fully automated and unmonitored way.
#  *           Maintains Perforce change list history on GitHub
#  *           Helps in syncing already migrated branches, supports creating and syncing new branches created post migration etc.
#  *           Feature to convert Perforce folders to branches if needed along with syncing ability in this scenario as well        
#  * Author : Vivek Dubey
#  * Copyright : Intuit Inc @ 2021
#  ************************************************************************************************************************
##

# Below GITHUB_API points to OpenSource GitHUB APi URl, but please note that GITHUB_API URL may change as per organizations private GitHub instance and configurations
export GITHUB_API="https://api.github.com/api/v3"

if [ $# -eq 6 ]
then
  export PERFORCE_SOURCE=$1
  export PERFORCE_SOURCE_REPO_URL=$2
  export TARGET_GITHUB_REPO_NAME=$3
  export WITH_BRANCHES=$4
  export SYNC_BRANCHES=$5
  export SYNCING_NEW_BRANCHES=$6
elif [ $# -eq 4 ]
then
  export PERFORCE_SOURCE=$1
  export PERFORCE_SOURCE_REPO_URL=$2
  export TARGET_GITHUB_REPO_NAME=$3
  export WITH_BRANCHES=$4  
  export SYNC_BRANCHES=
  export SYNCING_NEW_BRANCHES=NO
elif [  $# -eq 3 ]
then
  export PERFORCE_SOURCE=$1
  export PERFORCE_SOURCE_REPO_URL=$2
  export TARGET_GITHUB_REPO_NAME=$3
  export WITH_BRANCHES=NO
  export SYNC_BRANCHES=
  export SYNCING_NEW_BRANCHES=NO
else
   echo ""
   echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"
   echo "Usage:"
   echo "<Script> <PERFORCE_SOURCE> <PERFORCE_SOURCE_REPO_URL> <TARGET_GITHUB_REPO_NAME>"
   echo "OR"
   echo "<Script> <PERFORCE_SOURCE> <PERFORCE_SOURCE_REPO_URL> <TARGET_GITHUB_REPO_NAME> <WITH_BRANCHES>"
   echo "OR"
   echo "<Script> <PERFORCE_SOURCE> <PERFORCE_SOURCE_REPO_URL> <TARGET_GITHUB_REPO_NAME> <WITH_BRANCHES> <SYNC_BRANCHES> <SYNCING_NEW_BRANCHES>"
   echo ""
   echo "Valid Inputs to script:"
   echo "<PERFORCE_SOURCE>: ABC, XYZ or KLM to be used define different GitHub orgs"
   echo "<PERFORCE_SOURCE_REPO_URL>: A valid perforce repo path on source Perforce that needs to be migrated"
   echo "<TARGET_GITHUB_REPO_NAME>: Name of the new repo to be created on GitHub"
   echo "<WITH_BRANCHES>: YES or NO. By default it is NO"
   echo "<SYNC_BRANCHES>: Perforce branch names separated by comma(,) to be synced to GitHub repo"
   echo "<SYNCING_NEW_BRANCHES>: YES or NO. Works only when SYNC_BRANCHES field is having valid branch name as input"
   echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"
   echo ""
   exit 1
fi

check_empty() {
   name=$1
   value=$2
   if [ -z $value ]
   then
     echo ""
     echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"
     echo "Define Perforce ENV vars: P4PORT, P4PASSWD, P4USER"
     echo ""
     echo "Define GitHub ENV vars: GUSER, GPWD"
     echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"
     echo ""
     exit 2
   fi
}

check_perforce_repo() {
  perforce_repo=$1
  checkValue=$(p4 -s dirs ${perforce_repo})
  if [[ "${checkValue}" =~ "info:" ]]
  then
     echo ""
     echo "${perforce_repo} branch exists"
     echo ""
  else
     echo ""
     echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"     
     echo "Source ${perforce_repo} branch does NOT exists"
     echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"  
     exit 3
  fi
}

clean_repo_dir() {
   if [ -d ${repo_dir} ]
   then
       rm -rf ${repo_dir}
   fi
}

set_github_org() {
   export GITHUB_ORG="MyGitHubOrg"
   if [[ "${PERFORCE_SOURCE}" =~ "//my/ABC" ]]
   then
       export GITHUB_ORG="ABC"
   elif [[ "${PERFORCE_SOURCE}" =~ "//all/XYZ" ]]
   then
       export GITHUB_ORG="XYZ"
   elif [[ "${PERFORCE_SOURCE}" =~ "//yours/KLM" ]]
   then
       export GITHUB_ORG="KLM"
   fi
}

check_if_github_repo_exists() {
    value=$(curl -k -s -u "${GUSER}:${GPWD}" ${GITHUB_API}/search/repositories?q=${TARGET_GITHUB_REPO_NAME}|grep full_name)
    if [[ $value =~ "${GITHUB_ORG}/${TARGET_GITHUB_REPO_NAME}" ]]
    then
       echo ""
       echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"
       echo "${GITHUB_ORG}/${TARGET_GITHUB_REPO_NAME} already exists on GitHub, please check and rerun"
       echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++" 
       exit 4
    fi
}

create_github_repo() {
  curl -k -s -f -u "${GUSER}:${GPWD}"  ${GITHUB_API}/orgs/${GITHUB_ORG}/repos --data "{\"name\": \"${TARGET_GITHUB_REPO_NAME}\"}" 1>/dev/null 
}

git_clone_perforce() {
   export CLONE_REPO="${PERFORCE_SOURCE_REPO_URL}@all"
   if [[ ${CLONE_REPO} =~ "//my" ]]
   then
       export CLONE_REPO="${PERFORCE_SOURCE_REPO_URL}/...@all"
   fi
   
   clean_repo_dir
   git p4 clone ${CLONE_REPO} ${repo_dir} 
   
   if [ ! -d ${repo_dir} ] 
   then
       echo ""
       echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"
       echo "git p4 cloned dir ${repo_dir} does not exist .... please check and rerun again .... exiting ......"
       echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++" 
       exit 5       
   fi
}

push_changes_to_github() {
    branch=$1
    cd ${repo_dir}
    if [ "${branch}" != "master" ]
    then
       git checkout -b $branch
    fi
    git config --global user.email "vivek*****@gmail.com"
    git config --global user.name "Vivek Dubey"
    git remote add origin https://${GUSER}:${GPWD}@github.com/${GITHUB_ORG}/${TARGET_GITHUB_REPO_NAME}.git
    git add -f .
    if [ "${SYNC_FLAG}" = "YES" ]
    then
        git commit -m "syncing latest changes from ${branch} perforce branch $(date)"
    fi
    git push -u origin $branch -f
}

convert_folder_to_branch() {
     p4 dirs ${PERFORCE_SOURCE_REPO_URL}/* |while read line
     do
        clean_repo_dir
        branch_name=$(echo $line|awk -F'/' '{print $NF}')
        
        if [[ "$line" =~ "//my" ]]
        then
            git p4 clone $line/...@all ${repo_dir}
        else
            git p4 clone $line@all ${repo_dir}
        fi
        
        if [ ! -d ${repo_dir} ] 
        then
           echo ""
           echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"
           echo "git p4 cloned dir ${repo_dir} does not exist .... please check and rerun again .... exiting ......"
           echo "++++++++++++++++++++++ ERROR +++++++++++++++++++++++"
           echo ""
           exit 6
        fi
        push_changes_to_github $branch_name
     done
}

function sync_branches() {
    export SYNC_FLAG="YES"
    echo "${SYNC_BRANCHES}"|tr -s ',' '\n'|tr -d '[:blank:]'|while read branch_name
    do
        p4_dir="${PERFORCE_SOURCE_REPO_URL}/${branch_name}/..."
        p4_ws_root="${WORKSPACE}${SOURCE_URL_VAL}/${branch_name}/..."
        if [ "${branch_name}" = "master" ]
        then
            p4_dir="${PERFORCE_SOURCE_REPO_URL}/..."
            p4_ws_root="${WORKSPACE}${SOURCE_URL_VAL}/..."
        fi
        
        check_perforce_repo ${PERFORCE_SOURCE_REPO_URL}
        clean_repo_dir 
        
        if [ "${SYNCING_NEW_BRANCHES}" = "NO" ]
        then
           p4 sync -f ${p4_ws_root}
           git clone https://${GUSER}:${GPWD}@github.com/${GITHUB_ORG}/${TARGET_GITHUB_REPO_NAME}.git -b ${branch_name} ${repo_dir}
        else 
           git p4 clone ${p4_dir}@all ${repo_dir}
        fi
        
        if [ "${SYNCING_NEW_BRANCHES}" = "NO" ]
        then
           cp -rf ${p4_ws_root}/* {repo_dir}/
        fi
        push_changes_to_github $branch_name
    done
    clean_repo_dir
    exit $?
}

# set workspace var
export WORKSPACE=$(pwd)
export repo_dir=$(echo ${PERFORCE_SOURCE_REPO_URL}|awk -F'/' '{print $NF}')

# Perforce config , please set below env variables on the command line before running this script
export P4CLIENT="MIGRATE_REPO_TO_GITHUB"
export P4PORT=${P4PORT}
export P4PASWD=${P4PASSWD}
export P4USER=${P4USER}


check_empty P4CLIENT ${P4CLIENT}
check_empty P4PORT ${P4CLIENT}
check_empty P4USER ${P4USER}

echo ${P4CLIENT}>p4config.txt
echo ${P4PORT}>>p4config.txt
echo ${P4PASWD}>>p4config.txt
echo ${P4USER}>>p4config.txt

# check and set GitHub env variable
export GUSER=${GUSER}
export GPWD=${GPWD}

check_empty GUSER ${GUSER}
check_empty GPWD ${GPWD}

# Perforce login
p4 set P4CONFIG=${WORKSPACE}/p4config.txt
echo ${P4PASWD}| p4 login

# Delete and recreate client
p4 -d ${P4CLIENT} >/dev/null 2>&1

SOURCE_URL_VAL=$(echo ${PERFORCE_SOURCE_REPO_URL}|tr -s '//' '/')

p4 --field "Client=${P4CLIENT}" --field "Root=${WORKSPACE}" --field "View=${PERFORCE_SOURCE_REPO_URL}/... //${P4CLIENT}${SOURCE_URL_VAL}/..." client -o | p4 client -i >/dev/null 2>&1

echo ""
p4 info

# repo_dir clean up
clean_repo_dir

# check if perforce repo/branch exists
check_perforce_repo ${PERFORCE_SOURCE_REPO_URL}

# check and set GitHub Org
set_github_org

# sync branches 
if [[ -n "${SYNC_BRANCHES}" ]]
then
   sync_branches
fi

# check if GitHub repo exists
check_if_github_repo_exists

# create GitHub repo
create_github_repo

# git clone perforce
git_clone_perforce

# push the latst changs to GitHub
push_changes_to_github master

# convert peforce folder to GitHub branches
if [ "${WITH_BRANCHES}" = "YES" ]
then
   convert_folder_to_branch
fi

# repo_dir clean up at the end
clean_repo_dir
