ownerWithRepo="[GitHub Org]/[GitHub repo]"
branch="master"
curl -X PUT \
     -H 'Accept: application/vnd.github.luke-cage-preview+json' \
     -H "Authorization: Token ${GITHUB_API_TOKEN}" \
     -d '{
        "restrictions": null,
        "required_status_checks": null,
        "enforce_admins": null,
        "required_pull_request_reviews": { "required_approving_review_count": 2 }
    }' "https://github.api.com/api/v3/repos/${ownerWithRepo}/branches/${branch}/protection"
