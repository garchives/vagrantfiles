#!/bin/bash
# Author: JinsYin <jinsyin@gmail.com>

FLANNEL_VERSION=$1
DOCKER_VERSION=$2
ETCD_SERVER=$3
NETWORK_IFACE="eth1"

# 安装 flannel
yum install -y flannel-$FLANNEL_VERSION*

# 修改 flannel 配置
sed -i "s|FLANNEL_ETCD_ENDPOINTS=.*|FLANNEL_ETCD_ENDPOINTS=\"http://$ETCD_SERVER:2379\"|g" /etc/sysconfig/flanneld
sed -i "s|FLANNEL_ETCD_PREFIX=.*|FLANNEL_ETCD_PREFIX=\"/flannel/network\"|g" /etc/sysconfig/flanneld
sed -i "s|#FLANNEL_OPTIONS=.*|FLANNEL_OPTIONS=\"-iface=$NETWORK_IFACE\"|g" /etc/sysconfig/flanneld

# 运行 flannel
systemctl start flanneld.service
systemctl enable flanneld.service

# 安装　docker
yum install -y docker-$DOCKER_VERSION

# 安装 docker 后必须重启 docker，确保 docker0 使用 flannel 网络
systemctl restart docker.service
systemctl enable docker.service