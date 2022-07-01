#! /bin/sh

# Setup
# sudo apt-get update; sudo apt-get install jq curl grepcidr htop tmux nmap

# ./cdn_update.sh

server="luna:/home/sa"

scp $server/luna.json /tmp/luna.json
./luna -q --no-backup import /tmp/luna.json
rm /tmp/luna.json

rsync -r -u . $server
rsync -r -u $server/* .