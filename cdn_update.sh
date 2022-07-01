#!/bin/sh

echo 0.0.0.0/8 > cdns
echo 10.0.0.0/8 >> cdns
echo 100.64.0.0/10 >> cdns
echo 127.0.0.0/8 >> cdns
echo 169.254.0.0/16 >> cdns
echo 172.16.0.0/12 >> cdns
echo 192.0.0.0/24 >> cdns
echo 192.0.2.0/24 >> cdns
echo 192.88.99.0/24 >> cdns
echo 192.168.0.0/16 >> cdns
echo 198.18.0.0/15 >> cdns
echo 198.51.100.0/24 >> cdns
echo 203.0.113.0/24 >> cdns
echo 224.0.0.0/4 >> cdns
echo 233.252.0.0/24 >> cdns
echo 240.0.0.0/4 >> cdns

curl -s https://www.cloudflare.com/ips-v4 >> cdns
echo  >> cdns

curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq '.prefixes[].ip_prefix' -M | sed s/\"//g >> cdns
echo >> cdns

curl -s https://www.gstatic.com/ipranges/cloud.json | jq '.prefixes[].ipv4Prefix' -M | sed s/\"//g >> cdns
echo >> cdns

curl -s https://api.fastly.com/public-ip-list | jq '.addresses[]' -M | sed s/\"//g >> cdns
echo >> cdns

curl -s https://delivery.sotoon.cloud/ip-list.json | jq '.[]' -M | sed s/\"//g >> cdns
echo >> cdns
curl -s https://api.bgpview.io/asn/202319/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

curl -s https://www.arvancloud.com/fa/ips.txt >> cdns
echo >> cdns

curl -s https://cachefly.cachefly.net/ips/rproxy.txt >> cdns
echo >> cdns

curl -s https://support.maxcdn.com/hc/en-us/article_attachments/360051920551/maxcdn_ips.txt >> cdns
echo >> cdns

curl -s https://download.microsoft.com/download/0/1/8/018E208D-54F8-44CD-AA26-CD7BC9524A8C/PublicIPs_20200824.xml | grep -Po  '<IpRange Subnet="\K([\d\.\/]+)' >> cdns
echo >> cdns

curl -s https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips | jq '.CLOUDFRONT_GLOBAL_IP_LIST[], .CLOUDFRONT_REGIONAL_EDGE_IP_LIST[]' -M | sed s/\"//g >> cdns
echo >> cdns

curl -s -X POST https://my.incapsula.com/api/integration/v1/ips | jq '.ipRanges[]' -M | sed s/\"//g >> cdns
echo >> cdns

curl -s https://api.fastly.com/public-ip-list | jq '.addresses[]' -M | sed s/\"//g >> cdns
echo >> cdns

# Akamai
for asn in 12222 133103 16625 16702 17204 18680 18717 20189 20940 21342 21357 21399 22207 22452 23454 23455 23903 24319 26008 30675 31107 31108 31109 31110 31377 33047 33905 34164 34850 35204 35993 35994 36183 393560 39836 55409 55770
do
    curl -s https://api.bgpview.io/asn/$asn/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
    echo >> cdns
done
echo 103.238.148.0/22 >> cdns
echo 104.64.0.0/10 >> cdns
echo 103.41.68.0/22 >> cdns
echo 104.64.0.0/10 >> cdns

# CDNetworks
curl -s https://api.bgpview.io/asn/36408/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# DDoS Guard
curl -s https://api.bgpview.io/asn/57724/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# Qrator
curl -s https://api.bgpview.io/asn/200449/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# StackPath
curl -s https://api.bgpview.io/asn/12989/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# StormWall
curl -s https://api.bgpview.io/asn/59796/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# Sucuri
curl -s https://api.bgpview.io/asn/30148/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# X4B
curl -s https://api.bgpview.io/asn/136165/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# CDNNETWORKS
curl -s https://api.bgpview.io/asn/36408/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# GmbH
curl -s https://api.bgpview.io/asn/24940/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns


# OVH
curl -s https://api.bgpview.io/asn/16276/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns


# X Sher: Viettel, China dog
curl -s https://api.bgpview.io/asn/7552/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns
curl -s https://api.bgpview.io/asn/38623/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns
curl -s https://api.bgpview.io/asn/4134/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# DoD
curl -s https://api.bgpview.io/asn/749/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

# Indonesia
curl -s https://api.bgpview.io/asn/7713/prefixes | jq '.data.ipv4_prefixes[].prefix' -M | sed s/\"//g >> cdns
echo >> cdns

cat cdns | grep -E "[\d\.\/]+" > /tmp/cdns
mv /tmp/cdns cdns
