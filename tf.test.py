from scapy.all import *

port = 1111
in_packet_count = 0
in_byte_count = 0
out_packet_count = 0
out_byte_count = 0
time = 10


def packet_handler(packet):
    global in_packet_count, in_byte_count, out_packet_count, out_byte_count

    if TCP in packet and (packet[TCP].sport == port or packet[TCP].dport == port):
        if packet[TCP].dport == port:
            # 入站流量
            in_packet_count += 1
            in_byte_count += len(packet)
        else:
            # 出站流量
            out_packet_count += 1
            out_byte_count += len(packet)


# 捕获15分钟内的数据包
sniff(filter="tcp port {}".format(port), prn=packet_handler, timeout=time)
# t = AsyncSniffer(prn=lambda x: x.summary(), store=False, filter="tcp")

# 计算平均速度
in_average_speed = in_byte_count / time  # 900秒 = 15分钟
out_average_speed = out_byte_count / time

print(
    "Average inbound speed in the last {} s: {:.2f} Mbps".format(
        time, in_average_speed * 8 / 1024 / 1024
    )
)
print(
    "Average outbound speed in the last {} s: {:.2f} Mbps".format(
        time, out_average_speed * 8 / 1024 / 1024
    )
)
