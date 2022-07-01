# Find subs
# regex = (?P<asset>.+)
# ./subfinder -d ${domain} -silent -nW
# echo ${domain} | ./dnsx -silent -resp-only -mx
# echo ${sub} | ./dnsx -silent -resp-only -mx
# echo ${domain} | ./dnsx -silent -resp-only -ns
# echo ${sub} | ./dnsx -silent -resp-only -ns

# curl -s "https://www.abuseipdb.com/whois/${domain}" -H "user-agent: Chrome" | grep -E '<li>\w.*</li>' | sed -E 's/<\/?li>//g' |sed -e 's/$/.${domain}/' | ./dnsx -silent
# curl -s "https://www.abuseipdb.com/whois/${sub}" -H "user-agent: Chrome" | grep -E '<li>\w.*</li>' | sed -E 's/<\/?li>//g' |sed -e 's/$/.${domain}/' | ./dnsx -silent

# Find urls
#regex = (?P<asset>.+)
# echo ${domain} | ./gau --subs 2>/dev/null

# GoSpider
# regex = (?P<asset>(?:[a-z]+://)[-a-zA-Z0-9:@;?&=/%\+\.\*!\(\),\$_\{\}\^~#|]+)
# echo ${domain} | ./httpx -silent | ./gospider.sh 
# echo ${sub}    | ./httpx -silent | ./gospider.sh

# LFI
#regex = (?P<tag>LFI) (?P<asset>.+)
echo "${sub}" | ./httpx -fs "<title>Roundcube Webmail :: Welcome to Roundcube Webmail</title>" -nc -silent | ./lfi.sh
echo "${url}" | ./httpx -fs "<title>Roundcube Webmail :: Welcome to Roundcube Webmail</title>" -nc -silent | ./lfi.sh

nuclei
regex = \[(?P<tag>.*?)\] \[(?:.*?)\] \[(?P<severity>.*?)\] (?P<asset>\S+)( \[(?P<value>.*?)\])?
./nuclei -u "${url}" -nts -nc -silent -es info

