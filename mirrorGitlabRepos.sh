#!/bin/bash

export gitlab_token=<gitlabToken>
rm -rf repolist
jenkins_secret=<jenkins_secret>
wget --quiet -O - --auth-no-challenge --no-check-certificate --http-user <username> --http-password $jenkins_secret <Jenkins Job Url>/lastSuccessfulBuild/artifact/repolist > repolist

cat repolist|sort|uniq| while read line
do
 echo "***** $line *******"
 repoName=$(echo $line|cut -d',' -f1)
 repoUrl=$(echo $line|cut -d',' -f2)
 projectId=$(echo $line|cut -d',' -f3)
 test -d repo_dir && rm -rf repo_dir
 
 # Gitlab api to create a project on Gitlab named ${repoName} inside appropriate group
 curl --header "PRIVATE-TOKEN: ${gitlab_token}" -H "Content-Type: application/json" -d "{"name”:\”${repoName}\","namespace_id”:<gitlab_group_id>}" -X POST "<gitlabUrl>/api/v4/projects"

 git clone --bare ${repoUrl} repo_dir
 cd repo_dir
 git push --mirror <gitlab_url>:<gitlab_group_name>/${repoName}.git
 cd ..
  
 # if you want to archive existing projects , then enable below code and disable above code from line 19 till 22
 #echo "++++++ archiving project ${repoName} ++++++++"
 #curl -s -k --request POST --header "PRIVATE-TOKEN: $gitlab_token" "<gitlab_url>/api/v4/projects/${projectId}/archive"
 
done
