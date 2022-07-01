# Luna basic scripts

# Find subs
regex = (?P<asset>.+)

./subfinder -d ${domain} -silent #-nW

echo ${domain} | ./dnsx -silent -resp-only -mx
echo ${sub} | ./dnsx -silent -resp-only -mx
echo ${domain} | ./dnsx -silent -resp-only -ns
echo ${sub} | ./dnsx -silent -resp-only -ns

echo ${domain} | ./dnsx -silent -resp-only | ./nmap_cert_quick.sh | tee /tmp/cert_${domain}
echo ${sub} | ./dnsx -silent -resp-only | ./nmap_cert_quick.sh | tee /tmp/cert_${domain}
cat /tmp/cert_* > certs
rm /tmp/cert_*
sort -u -o certs certs

curl -s "https://www.abuseipdb.com/whois/${domain}" -H "user-agent: Chrome" | grep -E '<li>\w.*</li>' | sed -E 's/<\/?li>//g' |sed -e 's/$/.${domain}/' # | ./dnsx -silent

./amass enum -active -d ${domain} -nocolor -silent -o ${domain}.subs && cat ${domain}.subs && rm ${domain}.subs

# Find urls
regex = (?P<asset>.+)
echo ${domain} | ./gau --subs 2>/dev/null #| ./httpx -silent -ec -nc

# GoSpider
regex = (?P<asset>(?:[a-z]+://)[-a-zA-Z0-9:@;?&=/%\+\.\*!\(\),\$_\{\}\^~#|]+)
echo ${domain} | ./httpx -silent | ./gospider.sh
echo ${sub}    | ./httpx -silent | ./gospider.sh

# httpx
regex = (?P<asset>(?:\w+)://\S+) \[(?P<sc>\d*)\] \[(?P<title>[^\]]*)\] \[(?P<tag>[^\]]*)\]
echo "${sub}" | ./httpx -ec -nc -silent -sc -title  -td
./rustscan -a ${cidr} -r 1-65535 | grep Open | sed 's/Open //' | httpx -silent 

# nuclei
regex = \[(?P<tag>.*?)\] \[(?:.*?)\] \[(?P<severity>.*?)\] (?P<asset>\S+)( \[(?P<value>.*?)\])?
./nuclei -u "${url}" -nts -nc -silent -es info

# LFI
regex = (?P<tag>LFI) (?P<asset>.+)
echo "${url}" | ./httpx -nc -silent | ./lfi.sh
echo "${url}" | ./httpx -nc -silent | ./lfi.sh