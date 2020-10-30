#!/bin/bash
# echo "a.b.c.txt" | rev | cut -d"." -f2-  | rev

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
#echo "$string2"
#echo "$string3"
 
printf "Your are logged into database engine\nYou can create database, Create table, Insert, Update or delete\n"

read cmd
  
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
else
echo 'wrong';
fi
    
 


