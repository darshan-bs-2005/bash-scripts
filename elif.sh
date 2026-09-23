#! /bin/bash

echo " enter a days(1-7) : "
read day

if [ $day -eq 1 ]; then
	echo " $day is sunday"
elif [ $day -eq 2 ]; then
	echo " $day is monday"
elif [ $day -eq 3 ]; then
        echo " $day is tuseday"
elif [ $day -eq 4 ]; then
        echo " $day is wend"
elif [ $day -eq 5 ]; then
        echo " $day is thur"
elif [ $day -eq 6 ]; then
        echo " $day is friday"
elif [ $day -eq 7 ]; then
        echo " $day is sat"
else 
	echo " invaild input "
fi
