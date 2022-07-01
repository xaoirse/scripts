#!/bin/sh

curl -s "https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/bugcrowd_data.json" | jq -r '.[].targets.in_scope[] | select(.type == "website") | .target' | ./unfurl format %d | grep "^\*\..*.\..*" | grep -v "*$" | sed 's/*.//g' > domains.txt
curl -s "https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/hackerone_data.json" | jq -r '.[].targets.in_scope[] | select(.asset_type == "URL") | .asset_identifier' | ./unfurl format %d | grep "^\*\..*.\..*" | grep -v "*$" | sed 's/*.//g' >> domains.txt
curl -s "https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/intigriti_data.json" | jq -r '.[].targets.in_scope[] | select(.type == "url") | .endpoint' | ./unfurl format %d | grep "^\*\..*.\..*" | grep -v "*$" | sed 's/*.//g' >> domains.txt
./subfinder -silent -dL domains.txt > subdomains.txt
cat subdomains.txt | grep -v "\-\-" | sed -e 's/\.*[^\.]*\.[^\.]*$//; s/\./\n/g' | sort | uniq -c | sort -nr | cut -c9- > wlsub
