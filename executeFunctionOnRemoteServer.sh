# esnure that machine from where you are executing this has passwordless ssh connection in place if you are using this to automate something

export remote_user="<username>"
export remote_server="<remote server name or IP>"

function remoteFunction() {
    value=$1
    echo "Hi , I am exceuting on remote machine"
    echo $value
}

ssh "${remote_user}"@"${remote_server}" "$(typeset -f remoteFunction hello);remoteFunction hello"
