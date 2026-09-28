#! /bin/bash

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
CPU_INT=${CPU_USAGE%.*}

MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100}')
MEM_INT=${MEM_USAGE%.*}

DISK_USAGE=$(df -h | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$CPU_INT" -ge "$CPU_THRESHOLD" ]; then
    MSG="cpu usage high : ${CPU_INT}% | ${CPU_THRESHOLD}%"
    echo "$MSG"
elif [ "$MEM_INT" -ge "$MEM_THRESHOLD" ]; then
    MSG="Memory usage high : ${MEM_INT}% | ${MEM_THRESHOLD}%"
    echo "$MSG"
    
elif [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    MSG="DISK usage high : ${DISK_USAGE}% | ${DISK_THRESHOLD}%"
    echo "$MSG"
else 
  echo " system is woking no issue"
fi


