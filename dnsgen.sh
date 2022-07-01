#!/bin/bash

# Variables
if [ ! -z $2 ]; then
	wl=$2
else
	wl=../wl/wlsub30
fi

pr=$1

format () {
	printf "%-15s $1\n" ${2:1:-1}
}

beautify () {
	> /tmp/$1

	while IFS= read -r line; do
		format $line >> /tmp/$1
	done < $pr/$1

	cat /tmp/$1 | sort -n > $pr/$1
}

all () {
	./luna -q find domain -p $pr | ./dnsx -resp -silent  > $pr/dnsx_all
	./luna -q find sub    -p $pr | ./dnsx -resp -silent >> $pr/dnsx_all
	
	beautify dnsx_all
	filter dnsx_all
}

cert () {
	./luna -q find cidr   -p $pr | ./nmap_cert_quick.sh | sort -u > $pr/cert 
    cat $pr/cert | xargs -I % bash -c "./luna -q --no-backup insert program $pr -a %" # Test
	cat $pr/cert | ./dnsx -resp -silent > $pr/dnsx_cert

	beautify dnsx_cert
	filter dnsx_cert
}

dnsgen () {
	./luna -q dnsgen -p $pr -w $wl > /tmp/dnsgen

	cat /tmp/dnsgen | ./dnsx  -resp -silent  > $pr/dnsx_dnsgen
	beautify dnsx_dnsgen
	filter dnsx_dnsgen

	cat /tmp/dnsgen | ./httpx -ip   -silent  > $pr/httpx_dnsgen
	beautify httpx_dnsgen
	# filter httpx_dnsgen

	# Server may responds to all http requests
    # cat $pr/httpx_dnsgen | cut -d ' ' -f1 | xargs -I % bash -c "./luna -q --no-backup insert program $pr -a %" # Test

}

# notif (ip, asset, file)
notif () {
	# If founded in cidrs
	cidr=$(./luna -q find cidr --asset $1)
	if [[ ! -z $cidr ]]; then
		program=$(./luna -q find program --asset $cidr)
		printf "$program %-18s %-15s $2\n" $cidr $1 
	fi
}

# whis (ip, asset, file) why 'file'?
whis () {
	# If isn't in cidrs
	cidr=$(./luna -q find cidr --asset $1)
	if [[ -z $cidr ]]; then
		
		# Filter cdns
		ip=$(echo "$1" | ./cdn_filter.sh)
		if [[ ! -z $ip ]]; then

			# Whois
			w=`whois $ip`
			c=`echo $w | grep -i "Amazon\|Microsoft\|Cloudflare\|Proofpoint\|Google\|Akamai\|Sotoon\|Fastly\|Arvan\|CAFEBAZAAR\|Maxcdn\|Incapsula\|Cloudfront\|CDNetworks\|X4B\|GmbH\|CHINANET\|DODIIS\|VIETTEL\|SUCURI\|Salesforce\|SENDGRID\|GoDaddy\|DigitalOcean\|UltraDNS\|CERFNET\|PANTHEON\|LVLT-ORG\|Internap Holding"`
			if [ -z "$c" ]; then
				echo $ip $2 
				echo "$w" | grep -i "NetRange:\|CIDR:\|inetnum:\|NetName:\|org-name:\|OrgName:\|Organization:\|OrgId:\|RTechName:\|descr:\|person:\|Customer:\|CustName:" 
				echo 
			fi
		fi
	fi
}

filter () {

	> $pr/$1_notif
	cat $pr/$1 | sed "s/ \+/ /" | sort -u -t ' ' -k1,1 | xargs -n 2 -P 20 -I % bash -c "notif % $1" | sort -t ' ' -k1,1 > $pr/$1_notif
	
	rm /tmp/whois*
	cat $pr/$1 | sed "s/ \+/ /" | sort -u -t ' ' -k1,1 | xargs -n 2 -P 10 -I % bash -c "whis % $1 > '/tmp/whois %' " 
	cat /tmp/whois* > $pr/$1_whois
	rm /tmp/whois*
}

export -f notif
export -f whis

mkdir -p $pr

all
# cert
dnsgen