# clone a repo e.g. in a directory named test_dir
git clone https://github.com/vivekdubeyvkd/jenkins_pipeline.git repo


# Go to Repo Dir
cd repo

# below set of commands will compute the branch name along with the last check-in time and latest commiter name
git branch -r | grep -v HEAD |while read line
do
   echo `git show --format="%ai,%ar,%an" $line|head -1`,$line 
done | sort -r 


# below set of commands will compute the branch name along with the last check-in time and latest commiter name
# it will store the result in a file named branch_list.txt in current directory
git branch -r | grep -v HEAD |while read line
do
   echo `git show --format="%ai,%ar,%an" $line|head -1`,$line 
done | sort -r  > branch_list.txt
