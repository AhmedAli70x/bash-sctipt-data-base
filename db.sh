#!/bin/bash
# echo "a.b.c.txt" | rev | cut -d"." -f2-  | rev

#init the server if it is not initialized before
function init {
	cd ~
	if ! [ -d ourdb ];
	then
		mkdir 'ourdb';
		if [ $? = 0 ]; then
			echo "database server initialized create";
		else
			echo 'error initializing the database server';
		fi
	fi 
}
#call init function
init


function create {
	case $1 in
	'database')
	if [[ -d $2 ]]
	then
	echo "$2  already exsit"
	else
	mkdir $2
	printf "\n$2 has been created at home directory\n"
	fi
	;;
	'table')   #table x in DB
	if [ $3 = 'in' ]
	then
	if [ -d $4 ]
	then 
	cd $($4)
	pwd
	if [[ -f $3 ]]
	then
	echo "$3  already exsit"
	 
	else
	
	touch $2
	printf "\n$2 table has been created in $4\n"
	fi
	
	else
	echo "\n $4 DB not exist"
	
	fi	
	fi
	
	
	
	
	;;
	*)
	printf "\n invalid name $2 {table or database} "
	;;
	esac 

}
function dropdb {
	if [ -n $1 ] && [ -d ~/ourdb/$1 ];then
		rm -r ~/ourdb/$1
		echo $1" has been deleted successfully"
	else
		echo 'database '$1' not exists'
	fi
}
function showdb {
	if [ -d ~/ourdb ];
	then
		ls ~/ourdb;
	else
		echo 'an error occured'
	fi
}

function droptable {
	if [ -d ~/ourdb ];
	then
		cd ~/ourdb
		if [ pwd = ~/ourdb/* ];then
			if [ -f ~/ourdb/*/$1 ]; then
				rm $1
				echo 'table '$1' deleted'
			else
				echo 'table '$1' does not exists'
			fi
		else
			echo 'you should select database first';
		fi
	else
		echo 'an error occured'
	fi
}

function usedb {
	if [ -d ~/ourdb ];
	then
		cd ~/ourdb
		if [ -n $1 ] && [ -d ~/ourdb/$1 ];then
			cd ~/ourdb/$1
			echo $1' now in used'
		else
			echo 'database '$1' does not exists';
		fi
	else
		echo 'an error occured'
	fi
}
function showtables {
	if [ -d ~/ourdb ];
	then
		if [[ "$PWD" = */ourdb/* ]]; then
			ls
		else
			echo 'use database first : use <database name>'
		fi
	else
		echo 'an error occured'
	fi
}
function whereme {
	if [ -d ~/ourdb ];
	then
		if [[ "$PWD" = */ourdb/* ]]; then
			awk -F/ '{print $NF}' <<< $(pwd)
		else
			echo 'use database first : use <database name>'
		fi
	else
		echo 'an error occured'
	fi
}

printf "Your are logged into database engine\nYou can create database, Create table, Insert, Update or delete\n"

while [  true ];
do
	read -p "ourdb>" cmd

	string1="$(cut -d' '  -f1 <<< $cmd)"
	string2="$(cut -d' '  -f2 <<< $cmd)"
	string3="$(cut -d' '  -f3 <<< $cmd)"
	string4="$(cut -d' '  -f4 <<< $cmd)"
	string5="$(cut -d' '  -f5 <<< $cmd)"

		
	if [ $string1 = 'create' ];
	then
		echo "$string1";
		cd ;
		pwd ;
		create  $string2 $string3 $string4 $string5
	elif [ $string1 = 'dropdb' ]; 
	then 
		dropdb $string2

	elif [ $string1 = 'show' ];
	then
		showdb
	elif [ $string1 = 'droptb' ];then
		droptable $string2
	elif [ $string1 = 'use' ];then
		usedb $string2
	
	elif [ $string1 = 'where' ];then
		whereme
	elif [ $string1 = 'showtables' ];then
		showtables
	elif [ $string1 = 'exit' ]; then
		break
	else
		echo 'wrong';
	fi
done
echo 'good bay'



