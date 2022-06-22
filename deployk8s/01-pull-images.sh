#!/bin/bash

. ./env

ORIGIN=registry.cn-hangzhou.aliyuncs.com/google_containers
ORIGIN=registry.aliyuncs.com/google_containers #registry.aliyuncs.com
DEST=myregistry.com/google_containers
VERSOIN="v${K8SVER}"

# coredns
DNS_REPO=""
DNS_VER="1.8.0"
DNS_VER_OK="v1.8.0"

# metrics
MTR_VER="v0.3.7"
MTR_REPO=""

:<<COMMENT
# basic images
K8S_IMAGES="kube-controller-manager kube-apiserver kube-scheduler kube-proxy"
for i in ${K8S_IMAGES};
do
	docker pull $ORIGIN/$i:${VERSOIN}
	docker tag $ORIGIN/$i:${VERSOIN} $DEST/$i:${VERSOIN}
	docker push $DEST/$i:${VERSOIN}
done
COMMENT

function download_others() {
	MTR_IMAGES="${MTR_REPO}kubesphere/metrics-server:${MTR_VER}"
	TAG_IMAGES="metrics-server/metrics-server:${MTR_VER}"
	docker pull ${MTR_IMAGES}
	docker tag ${MTR_IMAGES} $DEST/${TAG_IMAGES}
	docker push $DEST/${TAG_IMAGES}
        sed -i "s/metrics-server:v.*/metrics-server:${MTR_VER}/g"  ./metrics/metrics-server.yaml
}

function download_coredns() {
	# coredns URL is variable
	DNS_IMAGES="${DNS_REPO}coredns/coredns:$DNS_VER"
	docker pull ${DNS_IMAGES}
	docker tag ${DNS_IMAGES} $DEST/coredns:$DNS_VER_OK
	docker push $DEST/coredns:$DNS_VER_OK
}

function download_k8s_control() {
	# download k8s control-plane and push to private registry
	images=(`kubeadm config images list --kubernetes-version=$VERSOIN|awk -F '/' '{print $2}'`)
	for imagename in ${images[@]} ; do
		docker pull $ORIGIN/$imagename
		docker tag $ORIGIN/$imagename $DEST/$imagename
		docker push $DEST/$imagename
		#ctr -n k8s.io i pull $ORIGIN/$imagename
		#ctr -n k8s.io i tag $ORIGIN/$imagename k8s.gcr.io/$imagename
	done
}

function pull_from_registry_com() {
	images=(`kubeadm config images list --kubernetes-version=$VERSOIN|awk -F '/' '{print $2}'`)
	for imagename in ${images[@]} ; do
		docker pull $DEST/$imagename
		echo -n ""
	done

	DNS_IMAGES="${DNS_REPO}coredns/coredns:$DNS_VER"
	docker pull $DNS_IMAGES
	docker tag $DNS_IMAGES $DEST/coredns/coredns:${DNS_VER_OK}

	MTR_IMAGES="${MTR_REPO}kubesphere/metrics-server:${MTR_VER}"
	docker pull $DEST/${MTR_IMAGES}
}

if [[ $1 == "local" ]]; then
	echo "download from local"
	pull_from_registry_com
else
	download_k8s_control
	#download_coredns
	download_others
fi
