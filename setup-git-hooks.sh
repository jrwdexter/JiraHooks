#!/bin/sh
#

pushd `dirname $0` > /dev/null
DIR=`pwd -P`
popd > /dev/null
rm -r -f "$DIR/.git/hooks"
ln -s "$DIR/git_hooks" "$DIR/.git/hooks"

echo -e "\nThis script will setup git hook \033[0;32msymlinks\033[0m, as well as storing your JIRA \033[0;31musername\033[0m and \033[0;31mpassword\033[0m for use with commits."
echo -e "Username:Password pair is base 64 encoded and stored in the current directory under \033[0;31mjira-creds\033[0m."
echo -e "\n\n\033[0;34mNote:\033[0m A warning looking like 'WARNING: can't open config file' may appear."

# Get username/password
echo -e "\nPlease enter your JIRA \033[0;31musername\033[0m: "
read USERNAME
echo -e "\nPlease enter your JIRA \033[0;31mpassword\033[0m: "
read -s PASSWORD
echo

openssl enc -base64 <<< "$USERNAME:$PASSWORD" > "$DIR/jira-creds"

# Add jira-creds to .gitignore
if ! grep -q "jira-creds" "$DIR/.gitignore" ; then
    printf "\n\n# Jira Credentials\njira-creds" >> "$DIR/.gitignore"
fi

# Test authentication from JIRA with new creds.
echo -e "\nTesting JIRA credentials, please wait..."

RESULT=$(curl -s -D- -I -X GET -H "Authorization: Basic $(cat $DIR/jira-creds)" -H "Content-Type: application/json" "https://issues.nerdery.com/rest/api/2/project") > /dev/null

if grep -q "HTTP/1.1 200" <<< $RESULT ; then
    echo "Success!  Press enter to finish..."
    read nil
else
    echo "Failure.  Please try again..."
    read nil
fi
