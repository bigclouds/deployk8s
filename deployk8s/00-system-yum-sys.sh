#!/bin/bash

unalias cp
swapoff -a

# load br_netfilter
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

# disable vmw_vsock_vmci_transport which conflict with vhost_vsock
cat <<EOF | sudo tee /etc/modprobe.d/blacklist.conf 
install vmw_vsock_vmci_transport /bin/false
EOF

# bridge-nf-call
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# kubernetes yum source
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# docker yum source
cat <<EOF > /etc/yum.repos.d/docker-ce-tsinghua.repo 
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/7/x86_64/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg

[docker-ce-stable-debuginfo]
name=Docker CE Stable - Debuginfo $basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/7/debug-x86_64/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg

[docker-ce-stable-source]
name=Docker CE Stable - Sources
baseurl=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/7/source/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
EOF

#cni
mkdir -p /etc/cni/net.d /opt/cni/bin
cp -f cni/10-flannel.conflist /etc/cni/net.d

# kata
mkdir -p /etc/kata-containers
yum install pixman libpmem librados2 librbd1 -y

#others
systemctl stop firewalld ; systemctl disable firewalld
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config 
