#! /bin/bash

LOG_DIR="/var/log/"
DAYS=30

echo " clear log olders than $DAYS days in $LOG_DIR "

find $LOG_DIR -type f -name "*.log" -mtime +$DAYS -exec echo {} \;

find $LOG_DIR -type f -name "*.log" -mtime +$DAYS -exec rm -f {} \;

echo "log clean up completed"
