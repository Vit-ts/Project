#!/bin/bash
count=0

while true
do
    result=`curl -v localhost:"$PORT" 2> /dev/null`
    sleep 2
if [ ! -z "$result" ]; then 
    break;
elif [ "$count" -eq 45 ]; then
    exit 1
fi
echo "number of attampt is $count"
count=$(( count + 1 ))
done
