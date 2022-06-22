-----------------------------------
* ### preparation

    1. prepare disk(xfs quota)for docker or containerd, defaults to /data

* ### 00-system.sh preparation

    # ./00-system.sh
    1. install docker-ce, kubectl, kubeadm</br>
    2. cp ../docker/daemon.json /etc/docker/</br>
    **Please modify env file, REGISTRY is registry's ip,  MYIP is current master's ip,  APILBIP is lb's ip of api-server**</br>
    **harbor cert refers to create_harbor_cert.sh**

* ### 01-pull-images.sh

    download system images from aliyun, which are gotten via 'kubeadm config images list --kubernetes-version=$VERSOIN'</br>
    coredns and metrics-server are downloaded from docker.io

* ### 02-deploy-master.sh
    
    start the first master-node, it generates bootstrap token, certificate-key,  discovery-token-ca-cert-hash.</br>
    if succeeds, it outputs the commands of how to add a new control-plane and worker-node</br>
    *Notice init.yaml is for bootstrap, join.yaml is for joining new nodes*
    1. advertiseAddress [^master's ip]
    2. certSANs [^all masters' ip and domainname and vip]
    3. nodeRegistration
    4. etcd is local or external
    5. imageRepository
    6. controlPlaneEndpoint [^lb's dns or ip]
    7. networking [^serviceSubnet, podSubnet, podSubnet is same with kube-flannel.yml's Network]
    8. kubectl edit configmap kube-proxy -n kube-system [^proxy mode]

* ### 03-network.sh

    1. this script is to install flannel cni. coredns depends on cni

* ### 04-dashboard.sh

    1. this script is to add dashboard</br>
       *Notice NodePort is 30000*

* ### 05-metrics.sh

    一. this script is to add metrics-server</br>
    二. *Notice* if it is for kubeedge , use metrics-server.yaml-kubeedge and refer to https://kubeedge.io/en/docs/setup/keadm/</br>
    1. metrics-server must be after v0.4.0
    2. iptables -t nat -A OUTPUT -p tcp --dport 10350 -j DNAT --to $CLOUDCOREIPS:10003
    3. it uses hostnetwork mode
    4. enable option '–kubelet-use-node-status-port'

* ### 06-ingress-controller.sh

    1. this script is to add ingress-controller
       how to create ingress , run ingress.yaml, nginx-dp.yaml, nginx-svc.yaml

* ### 10-all-end.sh

    1. delete master taint

* ### others

    1. kubectl label node node5 node-role.kubernetes.io/worker=worker
    2. install harbor</br>
      + https://goharbor.io/docs/2.0.0/install-config/configure-https/</br>
      + refer to harbor directory</br>
