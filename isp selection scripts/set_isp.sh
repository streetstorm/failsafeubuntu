#!/bin/sh

case $1 in
        ISP1)
                ip rule del from 192.168/16 to 192.168/16 table main
                while ip rule del from any table 101;do true;done
                while ip rule del from any table 102;do true;done

                ip rule add from 192.168.13.0/24 table 101
                ip rule add from 192.168/16 to 192.168/16 table main

                /sbin/ip route flush cache
                /usr/sbin/conntrack -F
        ;;
        ISP2)
                ip rule del from 192.168/16 to 192.168/16 table main
                while ip rule del from any table 101;do true;done
                while ip rule del from any table 102;do true;done

                ip rule add from 192.168.13.0/24 table 102
                ip rule add from 192.168/16 to 192.168/16 table main

                /sbin/ip route flush cache
                /usr/sbin/conntrack -F
        ;;
        ISP1ISP2)
                ip rule del from 192.168/16 to 192.168/16 table main
                while ip rule del from any table 101;do true;done
                while ip rule del from any table 102;do true;done

                ip rule add from 192.168.13.0/25 table 101
                ip rule add from 192.168.13.128/25 table 102
                ip rule add from 192.168/16 to 192.168/16 table main

                /sbin/ip route flush cache
                /usr/sbin/conntrack -F
        ;;
esac
