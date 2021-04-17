# Define below variables related to GitHub
export GIT_API_URL='https://api.github.com/api/v3'
export GIT_ORG="my_org"
export GIT_REPO_NAME="my_repo"
export GITHUB_USER="<your GitHub username>"
export GITHUB_API_TOKEN="<your GitHub API token or GitHub password>"

# Define the value of tag that needs to be validated 
export input_tag_name="my_tag"

# Make GitHub rest API call to check if tag exists on remote
tag_json_output=$(curl -k -u "${GITHUB_USER}:${GITHUB_API_TOKEN}" "${GIT_API_URL}/repos/${GIT_ORG}/${GIT_REPO_NAME}/git/ref/tags/${tag_name}")

# Check is tag exists, we will use tag_json_output for this purpose, no need to parse it
if [[ "${tag_json_output}" =~ "refs/tags/${input_tag_name}" ]]
then
    echo "TAG ${input_tag_name} already exists"
else
    echo "TAG ${input_tag_name} does not exist"
fi
