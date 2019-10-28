user=`whoami`
echo "user is $user"
sudo -u otheruser -i /bin/bash - <<-'EOF'
whoami
eval user2=$(whoami)
echo "otheruser $user2"
EOF
echo "out of user shell"
