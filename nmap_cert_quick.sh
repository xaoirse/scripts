#!/bin/sh

while read -r IP;
do
	nmap -Pn $IP -p 53,80,443,8000,8080 --script ssl-cert -oX - | grep -oP "\K[a-z0-9]{1,63}([\-\.]{1}[a-z0-9]{1,63})*\.[a-z]{2,6}" |  grep -vP "\.x[ms]l$" | grep -vP "\.cr[lt]$" | sort -u 
done