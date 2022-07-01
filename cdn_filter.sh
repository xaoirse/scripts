#! /bin/bash

while read -r IP;
do
	h=`echo $IP | grep -oP "\K(?:[0-9]{1,3}\.){3}[0-9]{1,3}" | grepcidr -i -f cdns`
	if [ -z "$h" ]; then
		continue
	fi

	echo $IP

done


