#!/bin/bash

##
##
## This script will allow you to export all of your passwords from
## 1Password into a csv format that you can import into another
## password Manager. If you have more than one account you can uncomment
## the four lines in the elif clause.
## By default this will create a separate CSV for each of the vaults
## in your 1Password account. The CSV will have colums for the following
## information:
## URL, Username, Password, Notes, Title, Tags
##
## To run the command you need to make sure that this file is in the
## same folder as the 'op' binary that you downloaded from the
## 1Password website.
##
## You must also append the account name you use to login to 1Password
## after the name of this file. For example:
##
## 				sh ./opexport.sh email1@login.com
##

if [ $1 = "email1@login.com" ] # Change to match your login email.
then
	key="XX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX" # Change to your key
	sh="one"
#elif [ $1 = "email2@login.com" ]
#then
#	key="XX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
#	sh="two"
else
	echo "Username did not match known account."
	exit 1
fi
eval $(./op signin my.1password.com $1 $key --shorthand=$sh)
./op list vaults | jq -r '.[] | .uuid' > opvaults.json
while read v; do
	vault=$(./op get vault $v | jq -r '.name')
	./op list items --vault=$v | jq -r '.[] | .uuid' > "op"$sh$vault".json"
	echo "uuid","url","username","password","extra","name","grouping" > "op"$sh$vault".csv"
	while read p; do
		./op get item $p > item.json
		url=$(jq -r '.overview.url' item.json)
		username=$(jq '.details.fields[] | select(.designation=="username").value' item.json)
		password=$(jq '.details.fields[] | select(.designation=="password").value' item.json)
		extra=$(jq '.overview.notesPlain' item.json)
		name=$(jq '.overview.title' item.json)
		grouping=$(jq '.overview.tags[]' item.json)
		echo $p,$url,$username,$password,$extra,$name,$grouping >> "op"$sh$vault".csv"
	done <"op"$sh$vault".json"
done <opvaults.json
	
