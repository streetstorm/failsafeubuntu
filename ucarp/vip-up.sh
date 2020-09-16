#!/bin/sh
/sbin/ip addr add 192.168.13.254/24 dev "$1"

ip addr add 172.16.1.13/24 dev ens34
send_arp 172.16.1.13 `cat /sys/class/net/ens34/address` 172.16.1.254 ff:ff:ff:ff:ff:ff ens34

ip addr add 172.16.2.13/24 dev ens36
send_arp 172.16.2.13 `cat /sys/class/net/ens36/address` 172.16.2.254 ff:ff:ff:ff:ff:ff ens36

ip route add default via 172.16.1.254 table 101
ip route add default via 172.16.2.254 table 102

route delete default
#route add default gw 172.16.1.254
