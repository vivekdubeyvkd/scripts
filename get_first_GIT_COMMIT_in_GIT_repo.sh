# resource https://stackoverflow.com/questions/5188914/how-to-show-first-commit-by-git-log

git clone https://github.com/vivekdubeyvkd/scripts.git local_repo
cd local_repo

#method 1
git rev-list --max-parents=0 HEAD

#mehtod 2
git rev-list --parents HEAD | egrep "^[a-f0-9]{40}$"

#method 3
git log --pretty=oneline --reverse | head -1
