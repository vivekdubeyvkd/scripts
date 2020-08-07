# all commits between two GIT commits ignoring merge commits
git log --no-merges <GIT_COMMIT_HASH1>..<GIT_COMMIT_HASH2> --oneline
 
# all commits between two GIT commits along with merge commits
git log <GIT_COMMIT_HASH1>..<GIT_COMMIT_HASH2> --oneline

# commit diffs between two GIT branches
git log origin/<branch1>..origin/<branch2> --oneline
