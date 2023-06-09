tc qdisc add dev eth0 root handle 1: htb default 100
tc class add dev eth0 parent 1:0 classid 1:100 htb rate 100Mbit ceil 100Mbit
tc class add dev eth0 parent 1:100 classid 1:20 htb rate 20Mbit ceil 20Mbit

# tc qdisc add dev eth0 parent 1:20 handle 20: sfq perturb 10

tc filter add dev eth0 parent 1:20 protocol ip prio 1 u32 match ip sport 61026 0xffff flowid 1:20

tc filter add dev eth0 parent 1:20 protocol ip prio 1 u32 match ip sport 61027 0xffff flowid 1:20

tc filter add dev eth0 parent 1:0 protocol all prio 999 u32 match ip protocol 0 0x00 flowid 1:1

# ===================================

tc qdisc add dev eth0 root handle 1: htb default 1 && \
tc class add dev eth0 parent 1: classid 1:1 htb rate 100Mbit ceil 100Mbit && \
tc class replace dev eth0 parent 1:1 classid 1:ee26 htb rate 10Mbit ceil 10Mbit && \
tc class replace dev eth0 parent 1:1 classid 1:ee27 htb rate 10Mbit ceil 10Mbit && \
tc filter replace dev eth0 parent 1: handle 800::ee26 protocol ip prio 1 u32 match ip sport 61026 0xffff flowid 1:ee26 && \
tc filter replace dev eth0 parent 1: handle 800::ee27 protocol ip prio 1 u32 match ip sport 61027 0xffff flowid 1:ee27

tc filter add dev eth0 parent 1: protocol all prio 999 u32 match ip protocol 0 0x00 flowid 1:1

# 删除
tc filter del dev eth0 parent 1: protocol ip prio 1 handle 801::800 u32
tc filter del dev eth0 parent 1: protocol ip prio 1 handle 800::801 u32


tc filter del dev eth0 parent 1: protocol ip prio 1 u32 match ip sport 61027 0xffff
tc class del dev eth0 parent 1: classid 1:ee27 htb rate 10Mbit ceil 10Mbit



tc filter show dev eth0