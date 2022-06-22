###
# 10.100.0.0/10.200.0.0/192.178.0.0 is neutron's cidr. do not nat
iptables -t nat -I POSTROUTING  3 -s 10.100.0.0/16 -d 10.100.0.0/16 -j RETURN
iptables -t nat -I POSTROUTING  3 -s 10.100.0.0/16 -d 10.200.0.0/16 -j RETURN
iptables -t nat -I POSTROUTING  3 -s 10.100.0.0/16 -d 192.178.0.0/16 -j RETURN
