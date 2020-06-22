ownerWithRepo="[GitHub org]/[GitHub repo]"
TAG_NAME="test_tag"
GIT_COMMIT="<commit hash value>"
RELEASE_TAG_NAME="V1.0.0"
GITHUB_API_TOKEN="<GitHub API token, you can set this as environment variable>"

curl --data "{\"tag_name\": \"${TAG_NAME}\",\"target_commitish\": \"${GIT_COMMIT}\",\"name\": \"Creating release tag\",\"body\": \"Release of version ${RELEASE_TAG_NAME}\",\"draft\": false,\"prerelease\": false}" "https://github.api.com/api/v3/repos/${ownerWithRepo}/releases?access_token=${GITHUB_API_TOKEN}"
