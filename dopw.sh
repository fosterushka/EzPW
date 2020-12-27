#!/bin/bash
read -p "Type length of the password up to 32: " length
passwordCommand="tr -dc 'a-zA-Z0-9~!@$=-' < /dev/urandom | fold -w $length | head -n 1"
password=$(eval "$passwordCommand")
echo "You just generate a new password : $password"
exit 0
