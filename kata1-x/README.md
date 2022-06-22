# kata 1.X https://download.opensuse.org/repositories/home:/katacontainers:/releases:/x86_64:/
# kata 2.X http://mirrors.163.com/centos/8/virt/x86_64/kata-containers/Packages/k/
# cp /usr/share/defaults/kata-containers/configuration-qemu.toml  /etc/kata-containers/configuration.toml

# install dependency
yum install pixman libpmem librados2 librbd1 -y

# example
docker run --rm  --name aaa -it --runtime kata-runtime busybox sh
