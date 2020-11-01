#!/bin/bash
# echo "a.b.c.txt" | rev | cut -d"." -f2-  | rev
DELI='ourdb>'
dbDir=~/'.ourdb'
selectedDB=''
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
#create table
#columns types (int, text, date)
#primary key

#createtable tablename ([col1_name col1_type, col2_name col2_type], primary key col_name)
function createTable {
	#echo "create data function"
	#echo $@
	if [ -d $dbDir ];
	then
		if [[ "$PWD" = */.ourdb/* ]]; then
			#table name
			if [[ -n $2 ]]; then

				if [[ $2 =~ ^[a-z]+[a-z0-9_]*$ ]];then
					#check columns
					echo $3
				else
					echo 'Error: table name must start with alphabet and not contains special character'
				fi
			
			else
				echo 'Error: use help createtable'
			fi
		else
			echo 'use database first : use <database name>'
		fi
	else
		echo 'an error occured'
	fi
}

function selecttable {
	if [ -d $dbDir ];
	then
		if [[ -n "$selectedDB" ]]; then
			if [[ -n $1 && $1 != 'selecttable' ]]; then
				#check file existance
				if [ -f  $selectedDB/$1 ]; then
					#cn -> columns number
					read cn <<< `sed '1!d' $selectedDB/$1 | cut -d: -f2`
					let cn++
					col_arr=()
					for (( i=2; i < $cn+1; i++ ))
					do
						col_arr+=(`sed "${i}!d" $selectedDB/$1` )
					done
					sed "1,${cn}d" $selectedDB/$1
					echo
					# for value in "${col_arr[@]}"
					# do
					# 	echo $value
					# done
				else
					echo "table does not exist"
				fi
			else 
				echo "invalid table name"
			fi
		else
			echo "you should select database first, or use help command"
		fi	
	else
		echo 'an error occured'
	fi
}
#insert table_name
#col1: >>
#col2: >>
function insert {
	if [[ -n "$selectedDB" ]]; then
			if [[ -n $1 && $1 != 'insert' ]]; then
				if [ -f  $selectedDB/$1 ]; then
					#get columns numbers
					read cn <<< `sed '1!d' $selectedDB/$1 | cut -d: -f2`
					let cn++
					col_arr=()
					#get columns name and type
					for (( i=2; i < $cn+1; i++ ))
					do
						col_arr+=(`sed "${i}!d" $selectedDB/$1` )
					done
					# col_arr[0]
					# col_arr[1]
					# col_arr[2]
					line=""
					for (( i=0; i < $cn - 1; i++ ))
					do
						echo "insert $(cut -d: -f1 <<< ${col_arr[i]})"
						
						read f
						#validation
						line+=$f
						if [ $i -lt `expr $cn - 2` ]
						then
							line+=:
						fi				
					done
					echo $line >> $selectedDB/$1
					echo "record inserted"
				else
					echo "invalid table name"
				fi
			else
				echo "invalid table name"
			fi
	else
		echo "you should select database first, or use help command"
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
			selectedDB=$dbDir/$1
			DELI=$1">"
			echo $1' now in used'
		else
			echo "database $1 does not exists"
		fi
	else
		echo "Server not initialized..."
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
		createdb $string2
	elif [ $string1 = "createtable" ];then
		createTable ${cmd}
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
	elif [ $string1 = 'select' ];then
		selecttable $string2 
	elif [ $string1 = 'insert' ];then
		insert $string2 
	elif [ $string1 = 'clear' ]; then
		clear
	elif [ $string1 = 'help' ]; then
		echo
		cat $dbDir"/.help.txt"
	elif [[ $string1 = "exit" ]]
	then
		echo "good bay";
		exit
	else
		echo 'invalid command'
		#cat $dbDir/.help.txt
	fi
done
