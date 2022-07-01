#!/bin/bash

w=../wl/wlsub30
threads=20

while getopts "u:w:t" o; do
    case $o in
        u)
            url=$OPTARG
            ;;
        w)
            w=$OPTARG
            ;;
        t)
            threads=$OPTARG
            ;;
    esac
done
echo u $url w $w threads $threads
./x8 -u $url -H "HOST: %s" -w $w -m 1  --param-template "%k " -c $threads