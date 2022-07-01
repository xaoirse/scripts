#!/bin/bash

if [ ! -z $2 ]; then
	wl=$2
else
	wl=wlsub100
fi

export pr=$1

local_path=""
server_path=""

all () {
	./luna -q find domain -p  $pr > $pr/all
	./luna -q find sub    -p  $pr >> $pr/all

	resolve all dnsx
}

cert () {
	./luna -q find cidr -p $pr | xargs -I % bash -c 'echo % | ./nmap_cert_quick.sh' > $pr/cert
	resolve cert dnsx
}

dnsgen () {
	./luna -q dnsgen -p $pr > $pr/dnsgen

	cp $pr/dnsgen $pr/dnsgen_dnsx

	resolve dnsgen httpx
	resolve dnsgen_dnsx dnsx
	cat $pr/dnsgen_dnsx | sort -u -t' ' -k1,1 | xargs -I % bash -c 'filter % dnsgen_'
}

format () {
	printf "%-15s $1\n" ${2:1:-1}
}

resolve_ssh () {

	scp $pr/$1 ubuntu@luna:/home/ubuntu/w/all 

	if [[ $2 = dnsx ]]; then
		ssh ubuntu@luna 'cd /home/ubuntu/w; ./dnsx -l all -resp -silent > resolveds; rm all'
	else
		ssh ubuntu@luna 'cd /home/ubuntu/w; cat all | ./httpx -ip -silent > resolveds; rm all'
	fi

	scp ubuntu@luna:/home/ubuntu/w/resolveds  /tmp/$1
	cat /tmp/$1 | xargs -I % bash -c "format %" > $pr/$1
	sort -u -o $pr/$1 $pr/$1
	sort -n -t '.' -k1 -o $pr/$1 $pr/$1

	if [[ $1 != dnsgen_dnsx ]] || [[ $2 != dnsx ]]; then
		cat $pr/$1 >> $pr/resolveds
		sort -u -o $pr/resolveds $pr/resolveds
		sort -n -t '.' -k1 -o $pr/resolveds $pr/resolveds
	fi
}

resolve () {
	if [[ $2 = dnsx ]]; then
		./dnsx  -l $pr/$1 -resp -silent > /tmp/$1
	else
		./httpx -l $pr/$1 -ip   -silent > /tmp/$1
	fi

	cat /tmp/$1 | xargs -I % bash -c "format %" > $pr/$1
	sort -u -o $pr/$1 $pr/$1
	sort -n -t '.' -k1 -o $pr/$1 $pr/$1

	if [[ $1 != dnsgen_dnsx ]] || [[ $2 != dnsx ]]; then
		cat $pr/$1 >> $pr/resolveds
		sort -u -o $pr/resolveds $pr/resolveds
		sort -n -t '.' -k1 -o $pr/resolveds $pr/resolveds
	fi
}

filter () {
	if [[ -z $2 ]]; then
		return
	fi

	cidr=$(./luna -q find cidr --asset $1)
	if [[ ! -z $cidr ]]; then
		program=$(./luna -q find program --asset $cidr)
		printf "$program %-18s %-15s $2\n" $cidr $1 >> $pr/$3notif
		return
	fi

	ip=$(echo "$1" | ./cdn_filter.sh)
	if [[ ! -z $ip ]]; then

		w=`whois $ip`
		c=`echo $w | grep -i "Amazon\|Microsoft\|Cloudflare\|Proofpoint\|Google\|Akamai\|Sotoon\|Fastly\|Arvan\|CAFEBAZAAR\|Maxcdn\|Incapsula\|Cloudfront\|CDNetworks\|X4B\|GmbH\|CHINANET\|DODIIS\|VIETTEL\|SUCURI"`
		if [ -z "$c" ]; then
			echo $ip $2 >> $pr/$3orgs
			echo "$w" | grep -i "NetRange:\|CIDR:\|inetnum:\|NetName:\|org-name:\|OrgName:\|Organization:\|OrgId:\|RTechName:\|descr:\|person:" >> $pr/$3orgs
			echo >> $pr/$3orgs
		fi
	fi
}

insert () {
	program=$(./luna -q find program --asset $1)
	if [[ ! -z $program ]]; then
		./luna -q --no-backup insert program $program -a $2 -q --no-backup	
	fi
}

export -f filter
export -f format
export -f insert

mkdir -p $pr

> $pr/notif
> $pr/dnsgen_notif
> $pr/resolveds
> $pr/orgs
> $pr/dnsgen_orgs

# eval `ssh-agent -s`
# ssh-add ~/.ssh/luna

# cert
all
dnsgen
cat $pr/resolveds | sed 's/\s\+/ /g' | xargs -I % bash -c 'insert %'
cat $pr/resolveds | sort -u -t ' ' -k1,1 | sed 's/\s\+/ /g' | xargs -I %  bash -c 'filter %'
