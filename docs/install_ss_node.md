## OS Image

```text
Centos 7 x86_64 bbr
```

## Basic

```bash
yum update -y
yum install -y yum-utils
yum install -y epel-release
yum-config-manager --enable epel

yum install -y \
    openssl-devel git-core zlib gcc-c++ \
    patch readline readline-devel libyaml-devel libffi-devel \
    make bzip2 autoconf automake libtool bison curl \
    sqlite-devel net-tools python2-pip telnet nc htop
```

## Set Iptables

```bash
systemctl disable firewalld
systemctl stop firewalld
systemctl enable iptables
systemctl start iptables

iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
iptables -A INPUT -p tcp --dport 22000:23000 -j ACCEPT
iptables -A INPUT -p udp --dport 22000:23000 -j ACCEPT
iptables -A INPUT -p tcp --dport ${SSH_CLIENT##* } -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -P INPUT DROP 

service iptables save
```

## Update Linux Kernel

```bash
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml-4.20.10-1.el7.elrepo.x86_64
grub2-set-default 'CentOS Linux (4.20.10-1.el7.elrepo.x86_64) 7 (Core)'
```

## Reboot the Server

```bash
reboot
```

## Install Docker

```bash
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

systemctl enable docker
systemctl start docker
```

## Set Docker API 

```bash
mkdir -p  /etc/systemd/system/docker.service.d/
touch /etc/systemd/system/docker.service.d/override.conf
```

Add config to `/lib/systemd/system/docker.service` : 
```text
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://%{dashboard_server_ip}:%{port}
```

```bash
systemctl daemon-reload
systemctl restart docker.service
```

## Pull Shadowsocks Image

```bash
docker pull shadowsocks/shadowsocks-libev
```

Start a container to test:

```bash
docker run \
    -e PASSWORD=%{YourPassword} -e METHOD=aes-256-cfb \
    -p %{HostPort}:8388/tcp -p %{HostPort}:8388/udp \
    --rm \
    -m 20M \
    --name first-test \
    -d shadowsocks/shadowsocks-libev
```


## References

[https://success.docker.com/article/how-do-i-enable-the-remote-api-for-dockerd](https://success.docker.com/article/how-do-i-enable-the-remote-api-for-dockerd)

[https://docs.docker.com/engine/api/v1.39/](https://docs.docker.com/engine/api/v1.39/)

[https://docs.docker.com/engine/reference/commandline/run/](https://docs.docker.com/engine/reference/commandline/run/)

[https://hub.docker.com/r/shadowsocks/shadowsocks-libev/dockerfile](https://hub.docker.com/r/shadowsocks/shadowsocks-libev/dockerfile)
