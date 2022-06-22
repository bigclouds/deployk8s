#!/bin/bash

. ./env

# readme
# kubeadm config print init-defaults > init.yaml
# kubeadm config print join-defaults > join.yaml

# 1. run kubeadm with init.yaml 
TOKEN=`kubeadm token generate`; echo $TOKEN > secret/token
CERT=`kubeadm certs certificate-key`; echo $CERT > secret/certificate_key
HOSTNAME=`hostname`
sed -i "s/token:.*/token: $TOKEN/g" init.yaml
sed -i "s/certificateKey:.*/certificateKey: $CERT/g" init.yaml
sed -i "s/name: .*/name: $HOSTNAME/g" init.yaml
sed -i "s/advertiseAddress: .*/advertiseAddress: $MYIP/g" init.yaml

grep "\- \"$MYIP\"" init.yaml
if [ $? -ne 0 ]; then
   sed -i "/certSANs:/a\  - \"$MYIP\"" init.yaml 
fi

sed -i "s/kubernetesVersion:.*/kubernetesVersion: v${K8SVER}/g" init.yaml

# involves init.yaml and kube-falnnel.yml
kubeadm init --config init.yaml --upload-certs --ignore-preflight-errors=all

CA_HASH=`openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null |    openssl dgst -sha256 -hex | sed 's/^.* //'` ; echo $CA_HASH > secret/discovery-token-ca-cert-hash

# if disable CA_HASH
# HAS_CAHASH="--discovery-token-unsafe-skip-ca-verification"
# 1.1 add a new control-plane
# kubeadm join apiserver.com:6443 --token $TOKEN --discovery-token-ca-cert-hash sha256:$CA_HASH $HAS_CAHASH --control-plane --certificate-key $CERT
# 1.2 add a new node
# kubeadm join apiserver.com:6443 --token $TOKEN --discovery-token-ca-cert-hash sha256:$CA_HASH $HAS_CAHASH

# 2. execute it on all nodes
mkdir -p $HOME/.kube
cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
