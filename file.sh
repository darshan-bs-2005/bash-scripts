#! /bin/bash

echo "enter the filepath : "

read file

if [ -e "$file" ];then
	echo " file is '$file' exits"
else 
	echo " no $file  file exits"
fi
