#!/bin/sh
/sbin/ip addr del 192.168.13.254/24 dev "$1"

ip addr del 172.16.1.13/24 dev ens34
route add default gw 192.168.13.254
