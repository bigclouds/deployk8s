# iptables -t nat -I OUTPUT 1 -p tcp -d 172.20.13.159 --dport 10250 -j DNAT --to $CLOUDCOREIPS:10003
iptables -t nat -A OUTPUT -p tcp --dport 10350 -j DNAT --to $CLOUDCOREIPS:10003
iptables -t nat -I PREROUTING 1 -p tcp -s 10.200.0.0/16 -d 172.20.13.159 --dport 10250 -j DNAT --to $CLOUDCOREIPS:10003
