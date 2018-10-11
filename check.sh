#!/bin/bash

function isnumber () 
{
	case $1 in
	    ''|*[!0-9]*) return 1 ;;
	    *) return 0 ;;
	esac	
}

#url of remote service sent as param to script (assuming it's valid http url)
url=$1
#make some random sleep time (0-3 sec) to get various results
rndsleep=$(( ( RANDOM % 4 )  ))
#get local time in Unix epoch
localtime=$(date "+%H:%M:%S")
#sleep - randomly 
sleep $rndsleep
#get remote time
remotetime=$(curl --silent $url)
if [ $? -ne 0 ]; then
	#error occured getting remote time - network issues
	echo "Service not available or accessible"
	exit 1
fi

# #verify validity of response - expecting number
# isnumber $remotetime
# if [ $? -ne 0 ]; then
# 	#case if server returns something outher than number - lire service not available or similar...
# 	echo "Not number - some error on server side. Server returned \"$remotetime\""
# 	exit 1
# fi

#calculate difference in time
diff=$(($localtime-$remotetime))
echo "Time difference is $diff"
# by definition of healthcheck diff in time up to 1 sec (including 1 sec) is OK
# "Write a healthcheck script that can be run externally to periodically check if the service is up and its clock is not desynchronised by more than 1 second."
if [[ $diff -lt -1 || $diff -gt 1 ]]; then
	# remote time is in the future or in the past
	# “Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.” — Buddha
	# if Buddha says it's not ok then next echo ... :)
	echo "notok"
	exit 1
fi

echo "ok"
exit 0