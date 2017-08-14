#!/bin/bash
# Author: JinsYin <jinsyin@gmail.com>

ETCD_VERSION=$1

yum install -y "etcd-$ETCD_VERSION"

sed -i "s|ETCD_LISTEN_CLIENT_URLS=.*|ETCD_LISTEN_CLIENT_URLS=\"http://0.0.0.0:2379\"|g" /etc/etcd/etcd.conf
sed -i "s|ETCD_ADVERTISE_CLIENT_URLS=.*|ETCD_ADVERTISE_CLIENT_URLS=\"http://0.0.0.0:2379\"|g" /etc/etcd/etcd.conf

systemctl restart etcd.service && systemctl enable etcd.service

etcdctl --no-sync set /flannel/network/config '{"Network": "10.20.0.0/16", "SubnetLen": 24, "Backend": {"Type": "vxlan"}}'