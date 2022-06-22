#### K8S skill

1. label node schedulable or not
    - kubectl patch node kubernetes-minion1 -p ' { " spec : { " unschedulable " : true } " } '
2. get dashboard secret
    - kubectl -n kube-system get secret admin-user-token-q8vlh -o jsonpath={.data.token} |base64 -d
3. kubeadm certificate-key, the key used to encrypt the control-plane certificates in the kubeadm-certs Secret,
	and to decrypt the certificate secrets uploaded by init when join
    - generate new one : kubeadm certs certificate-key
4. set kubelet's cri(docker/containerd)
    - kubectl annotate node k8s-master02  kubeadm.alpha.kubernetes.io/cri-socket=/var/run/dockershim.sock 
    - kubelet cmd line options 
        - --container-runtime=remote --runtime-request-timeout=15m --container-runtime-endpoint=unix:///run/containerd/containerd.sock --network-plugin=cni --cgroup-driver=systemd
4. list all tags of a image on hub.docker.com
   - curl -L -s https://registry.hub.docker.com/v1/repositories/hello-world/tags | json_reformat | grep -i name | awk '{print $2}' | sed 's/\"//g' | sort -u
   - curl -L -s 'https://registry.hub.docker.com/v2/repositories/library/hello-world/tags?page_size=1024' | json_reformat | grep -i name | awk '{print $2}' | sed 's/\"//g' | sort -u
