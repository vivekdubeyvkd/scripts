# below code snippet can be used to trigger vncserver in automated fashion inside scripts

display=$(shuf -i 110-510 -n 1)
export DISPLAY=":${display}"
mkdir -p $HOME/.vnc
echo "dummmypassword" >  ${HOME}/.vnc/passwd
chmod 600 ${HOME}/.vnc/passwd
vncserver ":${display}" -localhost -nolisten tcp -clean
