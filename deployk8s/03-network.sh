#!/bin/bash

kubectl create -f plugin/network/kube-flannel.yml 

# multus
# kubectl create -f plugin/network/multus-daemonset.yml
# kubectl create -f plugin/network/multus-bridge.yaml  
# kubectl create -f plugin/network/multus-flannel.yaml  
# kubectl create -f plugin/network/multus-kuryr.yaml
