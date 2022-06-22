#!/bin/bash

. ./env
./00-system-yum-sys.sh


# install docker-ce kubectl
yum install -y yum-utils bridge-utils
yum install -y docker-ce-20.10.8 docker-compose lsof containerd.io

mkdir -p /etc/docker/ /data/docker /data/harbor /data/etcd
cp -f ../docker/daemon.json /etc/docker/
cp -f ../containerd/config.toml /etc/containerd/
cp -f ../containerd/crictl.yaml /etc/
systemctl enable docker; systemctl restart docker
systemctl enable containerd; systemctl restart containerd

# download directly
#if [ ! -e /usr/bin/kubectl ] ;then
#    curl -LO https://dl.k8s.io/release/${K8SVER}/bin/linux/amd64/kubectl -o /usr/bin/kubectl
#    #curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#fi

yum install -y kubeadm-${K8SVER} kubelet-${K8SVER} kubectl-${K8SVER}
systemctl enable kubelet.service
mkdir -p /var/lib/kubelet/device-plugins/
echo '{}' >  /var/lib/kubelet/device-plugins/kubelet_internal_checkpoint

#sed -i 's/KUBELET_EXTRA_ARGS.*/KUBELET_EXTRA_ARGS="--v=0 --runtime-request-timeout=1m --read-only-port=10255 --fail-swap-on=false --container-runtime=docker --container-runtime-endpoint=unix:\/\/\/var\/run\/dockershim.sock"/g' /etc/sysconfig/kubelet
sed -i 's/KUBELET_EXTRA_ARGS.*/KUBELET_EXTRA_ARGS="--cgroup-driver=systemd --v=0 --runtime-request-timeout=1m --read-only-port=10255 --fail-swap-on=false --container-runtime=remote --container-runtime-endpoint=unix:\/\/\/run\/containerd\/containerd.sock"/g' /etc/sysconfig/kubelet
#sed -i 's/KUBELET_EXTRA_ARGS.*/KUBELET_EXTRA_ARGS="--v=0 --runtime-request-timeout=5m --fail-swap-on=false"/g' /etc/sysconfig/kubelet

# registry
grep myregistry.com /etc/hosts
if [ $? -ne 0 ]; then
    echo $REGISTRY myregistry.com >> /etc/hosts
    echo $APILBIP apiserver.com >> /etc/hosts
fi
sed -i "s/IP.1 =.*/IP.1 = $REGISTRY/g" harbor/v3.ext
