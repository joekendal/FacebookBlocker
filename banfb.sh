#!/bin/bash

read -r -d '' DOMAINS << EOM
# Block Facebook IPv4
127.0.0.1	facebook.com
127.0.0.1	www.facebook.com
127.0.0.1	login.facebook.com
127.0.0.1	www.login.facebook.com
127.0.0.1	fbcdn.net
127.0.0.1	www.fbcdn.net
127.0.0.1	fbcdn.com
127.0.0.1	www.fbcdn.com
127.0.0.1	static.ak.fbcdn.net
127.0.0.1	static.ak.connect.facebook.com
127.0.0.1	connect.facebook.net
127.0.0.1	www.connect.facebook.net
127.0.0.1	apps.facebook.com

# Block Facebook IPv6
fe80::1%lo0	localhost
fe80::1%lo0	facebook.com
fe80::1%lo0	www.facebook.com
fe80::1%lo0	login.facebook.com
fe80::1%lo0	www.login.facebook.com
fe80::1%lo0	fbcdn.net
fe80::1%lo0	www.fbcdn.net
fe80::1%lo0	fbcdn.com
fe80::1%lo0	www.fbcdn.com
fe80::1%lo0	static.ak.fbcdn.net
fe80::1%lo0	static.ak.connect.facebook.com
fe80::1%lo0	connect.facebook.net
fe80::1%lo0	www.connect.facebook.net
fe80::1%lo0	apps.facebook.com
EOM

GREEN='\033[0;32m'
NC='\033[0m'

if [[ "$OSTYPE" == "linux"* ]]; then
	echo "$DOMAINS" >> /etc/hosts
  echo -e "[${GREEN}*${NC}] Block rules written to /etc/hosts"
  for ip in $(whois -h whois.radb.net '!gAS32934' | tail -n +2 | head -n +1)
    do iptables -A INPUT -s $ip -j DROP
  done
  echo -e "[${GREEN}*${NC}] Facebook IPs blocked in IP tables"  
elif [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "bsd"* ]]; then
	echo "$DOMAINS" >> /etc/hosts
  echo -e "[${GREEN}*${NC}] Block rules written to /etc/hosts"
	pfctl -t blocklist -T add $(whois -h whois.radb.net '!gAS32934' | tail -n +2 | head -n +1) 2>/dev/null
  echo -e "[${GREEN}*${NC}] Facebook IPs blocked by the packet filter device"
elif [[ "$OSTYPE" == "msys"* ]]; then
	echo "$DOMAINS" >> c:\windows\system32\drivers\etc\hosts
  echo -e "[${GREEN}*${NC}] Block rules written to c:\windows\system32\drivers\etc\hosts"
  for ip in $(whois -h whois.radb.net '!gAS32934')
    do netsh advfirewall firewall add rule name="$ip" dir=in interface=any action=block remoteip=$ip
  done
  echo -e "[${GREEN}*${NC}] Facebook IPs blocked by the firewall"
fi
