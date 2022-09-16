#!/bin/bash

apt-get update
apt-get install -y kubelet=1.24.0-00 kubeadm=1.24.0-00 kubectl=1.24.0-00

##Stop auto updates for the K8s packages
apt-mark hold kubelet kubeadm kubectl 

kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.24.0


mkdir -p $HOME/.kube 
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 
chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

## Run this command to join other nodes to the cluster
## kubeadm token create --print-join-command