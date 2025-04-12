#!/bin/bash

yum update -y
yum install -y iptables-services
sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf

echo "# Add basic NAT rules (replace eth0 with correct interface if needed)"
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables-save | tee /etc/sysconfig/iptables

systemctl enable iptables
systemctl start iptables