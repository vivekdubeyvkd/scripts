if [[ $# -ne 1 ]] ; then
    echo "Specify ldap user name or ldap group name"
    echo "<script> [ldap username | ldap group name]"
    exit 1
fi

echo "searching for user with input detail"
ldapsearch -x -LLL -H '<ldap server>' -D '<ldap user name>' -w '<ldap password>' -b 'dc=<value>,dc=<value>,dc=<value>' "(&(objectClass=user)(name=$1))" | egrep '(dn|cn|givenName|sn|uid|memberOf): ' | sed 's/ CN=\([^,]*\).*$/ \1/'


echo "searching for group with input detail"
ldapsearch -x -LLL -H '<ldap server>' -D '<ldap user name>' -w '<ldap password>' -b 'dc=<value>,dc=<value>,dc=<value>' "(&(objectClass=group)(name=$1))" | grep "member:" | awk '{print $2}' | awk -F, '{print $1}' | cut -d= -f2

