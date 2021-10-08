#!/bin/bash

################################################
# In this GitHub rest API script
# we can learn to list all files under a directory on remote GitHub repo without actually cloning the repo locally
################################################

# define GitHub username and PAT for authentication
GITHUB_USER="[github username]"
GITHUB_PAT="[GitHub Personal Access Token(PAT)]"

# GitHub org and repo details 
GITHUB_ORG="vivekdubeyvkd"
GITHUB_REPO="python-utilities"
BRANCH="master"

# GitHub API to be used
GITHUB_API="https://api.github.com/repos/${GITHUB_ORG}/${GITHUB_REPO}/contents?ref=${BRANCH}"

# GitHub rest API call using authorization header for authentication
curl -H "Authorization: token $GITHUB_PAT" "${GITHUB_API}"

# GitHub rest API call using GitHub username and PAT for authentication
curl -u "$GITHUB_USER:$GITHUB_PAT" "${GITHUB_API}"
