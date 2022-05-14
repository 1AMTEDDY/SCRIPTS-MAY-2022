#!/bin/bash

USERNAME=$2 
PASSWORD=$3

addUser ()
{
	#check if password is null  if it is generate a random password
	if [ -z $PASSWORD ];
	then
	    PASSWORD=$(openssl rand -base64 32)
	fi

	#add user account then set passwd for user account that was created with second parameter then show that account has been created
	sudo useradd -m $USERNAME && echo "$USERNAME:$PASSWORD" | sudo chpasswd && echo "Account for $USERNAME has been created"

	#write the user name and password to a file
	touch credentials.txt

	echo "Welcome to our company here are the login credentials" >> credentials.txt
	echo  "Username: $USERNAME" >> credentials.txt
	echo "password: $PASSWORD" >> credentials.txt

	#send a file from the command line and remove credentials flie for security reasons
	echo "please find attached" | mail -a "credentials.txt" -s "here are your login credentials" "rsomto6@gmail.com" < /dev/null && \
 	echo "mail has been succesfully created" && \
	echo "deleting credentials file" && \
	rm -rf credentials.txt
	#copy company rules to users home directory
	sudo cp company_rules.txt "/home/$USERNAME"
}

deleteUser ()
{
	sudo userdel $USERNAME  && sudo rm -rf /home/$USERNAME && \
	echo "user $USERNAME has been deleted"
}

if [ "$1" == "add" ] 
then
    addUser
elif [ "$1" == "delete" ]
then
    deleteUser
else
   echo "you need to pass in 'add' or 'delete' as first argument"
fi
