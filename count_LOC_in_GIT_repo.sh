git clone https://github.com/vivekdubeyvkd/scripts local_repo
cd local_repo
GITHASH=$(git hash-object -t tree /dev/null)
git diff --shortstat ${GITHASH}
