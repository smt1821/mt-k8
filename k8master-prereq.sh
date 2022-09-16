#!/bin/bash

date

# Run these before installation
cat << EOF | sudo tee /etc/modules-load.d/containerd.conf  
overlay  
br_netfilter  
EOF

modprobe overlay
modprobe br_netfilter

cat << EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf 
net.bridge.bridge-nf-call-iptables = 1 
net.ipv4.ip_forward                = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
EOF

sysctl --system

apt-get update && apt-get install -y containerd

mkdir -p /etc/containerd

containerd config default | tee /etc/containerd/config.toml

systemctl restart containerd

swapoff -a

sed -i '/swap /s/^\(.*\)$/#\1/g' /etc/fstab

apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

## See the kubernetes address is there!

cd /etc/apt/sources.list.d && cat kubernetes.list

## Run this command as root
## curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -







