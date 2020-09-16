#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:$PATH

ip a | grep -q 'inet 192.168.13.254' || exit 0 

ip route delete default

ISP=''

ip route add default via 172.16.1.254

ping -c3 172.16.1.254 && ISP=ISP1 # лучше использовать ya.ru(or 8.8.8.8)

ip route delete default

ip route add default via 172.16.2.254

ping -c3 172.16.2.254 && ISP=${ISP}ISP2 # лучше использовать ya.ru(or 8.8.8.8)

ip route delete default

echo $ISP
# exit 0

touch /tmp/current_isp
test $ISP = "`cat /tmp/current_isp`" && exit 0

echo $ISP > /tmp/current_isp

/root/set_isp.sh $ISP
