#!/bin/bash

# 1.0 how add node after a while. launch the following command on master node, then paste its output on new node
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/#stacked-control-plane-and-etcd-nodes
kubeadm token create --print-join-command
# kubeadm init phase upload-certs --upload-certs
kubectl label node node5 node-role.kubernetes.io/worker=worker

# 2. execute it on all nodes
mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
