#!/bin/bash
# Author: JinsYin <jinsyin@gmail.com>

CEPH_RELEASE=$1

# ��װ yum-utils �� epel-release
sudo yum install -y yum-utils && sudo yum-config-manager --add-repo https://dl.fedoraproject.org/pub/epel/7/x86_64/ && sudo yum install --nogpgcheck -y epel-release && sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && sudo rm /etc/yum.repos.d/dl.fedoraproject.org*

# ��� ceph ����Դ
cat <<EOF > /etc/yum.repos.d/ceph-aliyun.repo
[ceph]
name=Ceph packages for \$basearch
baseurl=http://mirrors.aliyun.com/ceph/rpm-$CEPH_RELEASE/el7/\$basearch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://mirrors.aliyun.com/ceph/keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=http://mirrors.aliyun.com/ceph/rpm-$CEPH_RELEASE/el7/noarch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://mirrors.aliyun.com/ceph/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=http://mirrors.aliyun.com/ceph/rpm-$CEPH_RELEASE/el7/SRPMS
enabled=0
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://mirrors.aliyun.com/ceph/keys/release.asc
EOF

# ��� ceph �ٷ�Դ����ע�ͣ�
:<<SHELL
cat <<EOF > /etc/yum.repos.d/ceph.repo
[ceph]
name=Ceph packages for \$basearch
baseurl=http://download.ceph.com/rpm-$CEPH_RELEASE/el7/\$basearch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=http://download.ceph.com/rpm-$CEPH_RELEASE/el7/noarch
enabled=1
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=http://download.ceph.com/rpm-$CEPH_RELEASE/el7/SRPMS
enabled=0
priority=2
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
EOF
SHELL

#����װ $CEPH_RELEASE ���а������µ� ceph
yum install -y ceph