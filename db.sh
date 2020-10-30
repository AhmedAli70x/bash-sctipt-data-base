#!/bin/bash
# echo "a.b.c.txt" | rev | cut -d"." -f2-  | rev
DELI='ourdb>'
dbDir=~/'.ourdb'
#init the server if it is not initialized before
function init {
	if ! [ -d $dbDir ];
	then
		mkdir $dbDir;
		cp ./help.txt ${dbDir}/.help.txt
		if [ $? = 0 ]; then
			echo "database server initialized create";
		else
			echo 'error initializing the database server';
			exit
		fi
	fi
}
#call init function
init


# function create {
# 	case $1 in
# 	'database')
# 	if [[ -d $2 ]];
# 	then
# 		echo "$2  already exsit"
# 	else
# 		mkdir $2
# 	printf "\n$2 has been created at home directory\n"
# 	fi
# 	;;
# 	'table')   #table x in DB
# 	if [ $3 = 'in' ]
# 	then
# 	if [ -d $4 ]
# 	then 
# 	cd $($4)
# 	pwd
# 	if [[ -f $3 ]]
# 	then
# 	echo "$3  already exsit"
	 
# 	else
	
# 	touch $2
# 	printf "\n$2 table has been created in $4\n"
# 	fi
	
# 	else
# 	echo "\n $4 DB not exist"
	
# 	fi	
# 	fi
# 	;;
# 	*)
# 	printf "\n invalid name $2 {table or database} "
# 	;;
# 	esac 

# }

function createdb {
	if ! [ -d $dbDir ];then
		echo 'server error';
	elif [[ $1 = "createdb" ]];then
		echo 'Error: you can use help command'
	elif [ -n $1 ] && [ -d $dbDir/$1 ];then
		echo $1" database aleady exists"
	elif ! [[ $1 =~ ^[a-z]+[a-z0-9]*$ ]];then
		echo 'invalid database name, you can only use alphabet and number and start with character'
	elif [ -d $dbDir ] && [ -n $1 ] ; then
		mkdir $dbDir/$1
		echo "database $1 created"
	else
		echo 'Error: you can use help command'
	fi
}
function dropdb {
	if [ -n $1 ] && [ -d $dbDir/$1 ];then
		rm -r $dbDir/$1
		echo $1" has been deleted successfully"
	else
		echo 'database '$1' not exists. you can use help command'
	fi
}
function showdb {
	if [ -d ${dbDir} ];
	then
		ls $dbDir
	else
		echo 'an error occured'
	fi
}

function droptable {
	if [ -d $dbDir ];
	then		
		if [[ "$PWD" = */.ourdb/* ]];then
			if [ -f $dbDir/*/$1 ]; then
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
	if [ -d $dbDir ];
	then
		# cd $dbDir
		if [ -n $1 ] && [ -d $dbDir/$1 ];then
			cd $dbDir/$1
			DELI=$1">"
			echo $1' now in used'
		else
			echo 'database '$1' does not exists';
		fi
	else
		echo 'Server not initialized...'
		#init
	fi
}
function showtables {
	if [ -d $dbDir ];
	then
		if [[ "$PWD" = */.ourdb/* ]]; then
			if [ $( ls | wc -l ) = 0 ];then
				echo 'no tables to show'
			else
				ls
			fi
		else
			echo 'use database first : use <database name>'
		fi
	else
		echo 'an error occured'
	fi
}
function whereme {
	if [ -d $dbDir ];
	then
		if [[ "$PWD" = */.ourdb/* ]]; then
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
	
	read -p $DELI cmd

	string1="$(cut -d' '  -f1 <<< $cmd)"
	string2="$(cut -d' '  -f2 <<< $cmd)"
	string3="$(cut -d' '  -f3 <<< $cmd)"
	string4="$(cut -d' '  -f4 <<< $cmd)"
	string5="$(cut -d' '  -f5 <<< $cmd)"

		
	if [[ $string1 = 'createdb' ]];
	then
		# echo "$string1";
		# cd ;
		# pwd ;
		# create  $string2 $string3 $string4 $string5
		createdb $string2
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

	elif [ $string1 = 'clear' ]; then
		clear
	elif [ $string1 = 'help' ]; then
		cat $dbDir/.help.txt
	elif [ $string1 = 'exit' ]; then
		break
	else
		echo 'invalid command';
		cat $dbDir/.help.txt
	fi
done
echo "good bay"