#!/bin/sh

curl -s https://raw.githubusercontent.com/BonJarber/fresh-resolvers/main/resolvers.txt > resolvers

# curl -s https://public-dns.info/nameservers.txt | grep -oP "^\K(\d{1,3}\.){3}\d{1,3}$" >> _rslv

# cat _rslv | sort -u > resolvers
# rm _rslv
