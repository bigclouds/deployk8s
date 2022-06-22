#!/bin/bash

# 1. download keadm and kubeedge from https://github.com/kubeedge/kubeedge/releases/tag/v1.6.1

MY_IP=172.20.47.126
CLOUDCORE_DNS=k8s1.com
CLOUDCOREIPS="172.20.47.144 172.20.47.161 172.20.47.126"

keadm init --kubeedge-version=1.6.1  --advertise-address="${MY_IP}" --domainname="${CLOUDCORE_DNS}"
