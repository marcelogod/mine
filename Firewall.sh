echo " █████╗ ███╗   ██╗████████╗██╗██████╗ ██████╗  ██████╗ ███████╗"
echo "██╔══██╗████╗  ██║╚══██╔══╝██║██╔══██╗██╔══██╗██╔═══██╗██╔════╝"
echo "███████║██╔██╗ ██║   ██║   ██║██║  ██║██║  ██║██║   ██║███████╗"
echo "██╔══██║██║╚██╗██║   ██║   ██║██║  ██║██║  ██║██║   ██║╚════██║"
echo "██║  ██║██║ ╚████║   ██║   ██║██████╔╝██████╔╝╚██████╔╝███████║"
echo "╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝"

iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP  

iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP 
 
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP  

iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP

iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP 
iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP 
iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP 
iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP 
iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP 
iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP 
iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP 
iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP 
iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP  

iptables -t mangle -A PREROUTING -p icmp -j DROP  

iptables -t mangle -A PREROUTING -f -j DROP  

iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset  

iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT 
iptables -A INPUT -p tcp --tcp-flags RST RST -j DROP  

iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 20 -j ACCEPT 
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j DROP  

iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set 
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP  

iptables -N port-scanning 
iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN 
iptables -A port-scanning -j DROP

iptables -A INPUT -p tcp -m tcp --dport 25565 --tcp-option 8 --tcp-flags FIN,SYN,RST,ACK SYN -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp -m tcp --dport 25565 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 25565 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 150 --connlimit-mask 32 --connlimit-saddr -j DROP
iptables -A INPUT -p tcp -m tcp --dport 25565 --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr -j DROP
iptables -A INPUT -p tcp -m tcp --sport 123 -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp -m tcp --sport 389 -j REJECT --reject-with icmp-port-unreachable

iptables -A INPUT -p tcp -m state --state NEW -m limit --limit 50/second --limit-burst 50 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -j DROP
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m limit --limit 60/s --limit-burst 20 -j ACCEPT 
iptables -A INPUT -p tcp --tcp-flags RST RST -m limit --limit 2/s --limit-burst 2 -j ACCEPT 


output "Proteções DoS/AntiDDoS aplicadas com êxito."