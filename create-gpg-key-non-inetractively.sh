echo "Key-Type: 1" > gpg-key-gen
echo "Key-Length: 4096" >> gpg-key-gen
echo "Subkey-Type: 1" >> gpg-key-gen
echo "Subkey-Length: 4096" >> gpg-key-gen
echo "Name-Real: Vivek Dubey" >> gpg-key-gen
echo "Name-Email: vivekdubeyvkd@gmail.com" >> gpg-key-gen
echo "Passphrase: 123455" >> gpg-key-gen
echo "Expire-Date: 0" >> gpg-key-gen

gpg --batch --gen-key gpg-key-gen
gpg --export -a 'Vivek Dubey' > NEW-RPM-GPG-KEY
rpm --import NEW-RPM-GPG-KEY
