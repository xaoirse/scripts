#!/bin/bash

usage() {
    echo "-p <Program name> -w <Wordlist> -t <Threads> -S <HTTPS>"
}

# fuzz(ip)
fuzz() {
    # Getting Words Count (wc is different!)
    echo "jenchulichaeng"    | ./ffuf -u "$protocol://$1" -H "HOST: FUZZ" -w - -o /tmp/$1 -s > /dev/null 2>/dev/null
    fs=$(cat /tmp/$1 | jq ".results[].length")
    rl=$(cat /tmp/$1 | jq ".results[].redirectlocation")
    rm /tmp/$1

    echo "jenchulichaeng.$1" | ./ffuf -u "$protocol://$1" -H "HOST: FUZZ" -w - -o /tmp/$1 -s > /dev/null 2>/dev/null
    fs2=$(cat /tmp/$1 | jq ".results[].length")
    rl2=$(cat /tmp/$1 | jq ".results[].redirectlocation")
    rm /tmp/$1

    if [ rl == https://jenchulichaeng/ ] && [ rl2 == https://jenchulichaeng.$1/ ] ; then
        ./ffuf -w /tmp/w -u "$protocol://$1" -H "HOST: FUZZ" -fc 301 -t 20 -s -o /tmp/$pr/$1  > /dev/null 2> /dev/null
        return
    fi

    if [ ! -z $fs ] && [ ! -z $fs2 ] ; then
        ./ffuf -w /tmp/w -u "$protocol://$1" -H "HOST: FUZZ" -fs $(expr $fs - $fs / 1000 )-$(expr $fs + $fs / 1000 + 1 ),$(expr $fs2 - $fs2 / 1000 )-$(expr $fs2 + $fs2 / 1000 + 1 ),0 -t 20 -s -o /tmp/$pr/$1  > /dev/null 2> /dev/null
    fi
}

run() {
    
    # Make WordList
    cat $w > /tmp/w
    ./luna      dnsgen -qp $pr -w $w >> /tmp/w
    ./luna find    sub -qp $pr       >> /tmp/w
    ./luna find domain -qp $pr       >> /tmp/w

    # Run in Parallel
    mkdir -p /tmp/$pr
    ./luna find cidr -qp $pr -vv | xargs -P $threads -I % bash -c "fuzz %"

    # TODO hosts_new
    # Collect Data
    mkdir -p $pr
    touch ./$pr/hosts
    for f in $(ls /tmp/$pr); do

        file=$(cat /tmp/$pr/$f | jq -r '.results | sort_by(.length) | .[] | [.status, .length, .host, .redirectlocation] | @tsv')
        
        if [ $( echo "$file" | wc -l) -gt 1 ]; then
            echo $f      >> ./$pr/hosts
            echo "$file" >> ./$pr/hosts
            echo ""      >> ./$pr/hosts
        fi
    done

    # Clean
    rm /tmp/w /tmp/$pr/*
    rmdir /tmp/$pr
}

protocol="http"
w=../wl/wlsub30
threads=20

while getopts "p:w:t:s" o; do
    case $o in
        p)
            pr=$OPTARG
            ;;
        w)
            word=$OPTARG
            ;;
        t)
            threads=$OPTARG
            ;;
        s)
            protocol="https"
            ;;
        
        h | *)
            usage
            ;;
    esac
done

export -f fuzz
export pr
export protocol

run