#!/bin/sh

while read -r IP;
do
	sudo nmap -sS -Pn $IP -p 21,22,23,25,53,80,110,161,389,443,445,587,636,995,1025,1701,1723,2000,2483,2484,2601,3001,3128,3306,3389,3690,5060,5900,8000,8080,10443 --script ssl-cert -oX - 2>/dev/null | grep -oP "\K[a-z0-9]{1,63}([\-\.]{1}[a-z0-9]{1,63})*\.[a-z]{2,6}" |  grep -vP "\.x[ms]l$" | grep -vP "^\d.cr[lt]$" | sort -u 
done