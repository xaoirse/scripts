#!/bin/sh

# It finds all URL assets of a program

# Hackerone
([ ! -f "hackerone_data.json" ] || [ "$(find hackerone_data.json -mmin +120)" ] ) &&  wget https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/hackerone_data.json -O hackerone_data.json -q
cat hackerone_data.json | jq --arg name ".*$1.*" 'first(.[] | select(.handle|test($name; "i"))) | {name} | join(" ")'
cat hackerone_data.json | jq --arg name ".*$1.*" 'first(.[] | select(.handle|test($name; "i"))) | .targets.in_scope[] | select(.asset_type=="URL" or .asset_type=="CIDR") | {asset_identifier} | join(" ")' | sed 's/\"\*\.//' | sed 's/^\"//' | sed 's/\"$//'

# Bugcrowd
# Need more regex
([ ! -f "bugcrowd_data.json" ] || [ "$(find bugcrowd_data.json -mmin +120)" ] ) &&  wget https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/bugcrowd_data.json -O bugcrowd_data.json -q
cat bugcrowd_data.json | jq --arg name ".*$1.*" 'first(.[] | select(.name|test($name; "i"))) | {name} | join(" ")'
cat bugcrowd_data.json | jq --arg name ".*$1.*" 'first(.[] | select(.name|test($name; "i"))) | .targets.in_scope[] | {target} | join(" ")' | sed 's/\"\*\.//' | sed 's/^\"//' | sed 's/\"$//'

# Intigriti
([ ! -f "intigriti_data.json" ] || [ "$(find intigriti_data.json -mmin +120)" ] ) &&  wget https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/intigriti_data.json -O intigriti_data.json -q
cat intigriti_data.json | jq --arg name ".*$1.*" 'first(.[] | select(.handle|test($name; "i"))) | {name} | join(" ")'
cat intigriti_data.json | jq --arg name ".*$1.*" 'first(.[] | select(.handle|test($name; "i"))) | .targets.in_scope[] | select(.type=="url" or .type=="iprange") | {endpoint} | join(" ")' | sed 's/\"\*\.//' | sed 's/^\"//' | sed 's/\"$//'

# YesWeHack
([ ! -f "yeswehack_data.json" ] || [ "$(find yeswehack_data.json -mmin +120)" ] ) &&  wget https://raw.githubusercontent.com/arkadiyt/bounty-targets-data/master/data/yeswehack_data.json -O yeswehack_data.json -q
cat yeswehack_data.json | jq --arg name ".*$1.*" 'first(.[] | select(.id|test($name; "i"))) | {name} | join(" ")'
cat yeswehack_data.json | jq --arg name ".*$1.*" 'first(.[] | select(.id|test($name; "i"))) | .targets.in_scope[] | select(.type=="web-application" or .type=="ip-address" or .type=="api") | {target} | join(" ")' | sed 's/\"\*\.//' | sed 's/^\"//' | sed 's/\"$//'
