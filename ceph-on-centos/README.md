# Ceph On Vagrant For CentOS

`vagrant up` �����������Ĭ�ϻ������нڵ㰲װ���������Ӧ�� ceph ��������ʹ�� `ceph-deploy install` ��������װ ceph ����ʧ�ܣ����Ը���Դ�ķ�ʽ����װ��

## ϵͳ����

  * Centos 7.3.1611
  * Kernel 3.10.0-514.26.2
  * Ceph 10.2.x


## ��Ⱥ�ֲ�

hostname      | ip          | role              | components    |
------------- | ----------- | ----------------- | ------------- |
ceph-admin    | 172.72.1.10 | ceph-mon radosgw  | ceph ceph-radosgw ceph-deploy |
ceph-server-1 | 172.72.1.11 | ceph-mon ceph-osd | ceph |
ceph-server-2 | 172.72.1.12 | ceph-mon ceph-osd | ceph |

���У������ ceph ���� ceph-base��ceph-common��ceph-selinux��ceph-osd��ceph-mon��ceph-osd��ceph-mds �������`rpm -qa | grep ceph*`����

> ע�⣺ֱ��ͨ��Դ����װ ceph ʱĬ�ϲ��ᰲװ ceph-radosgw��ceph-release ���������ͨ�� `ceph-deploy install` ����װʱ���Զ���װ��


## ����

```bash
$ # ��� vagrant �� insecure_private_key �� ssh-agent ȷ��������������֮���������Կ��¼
$ ssh-add ~/.vagrant.d/insecure_private_key
```

```bash
$ # ������������Զ����� ceph
$ vagrant up
$
$ # ������������Բ�ִ�� provision��Ҳ���ǲ�ִ�в���ű�
$ vagrant reload --no-provision
```

```bash
$ # ������������������� hosts �ļ�������ֱ��ͨ��������������
$ # ��Ҫ�Ȱ�װ hostmanager ����� vagrant plugin install vagrant-hostmanager
$ vagrant hostmanager
```


## У��

* ceph-admin

```bash
$ vagrant ssh ceph-admin
[vagrant@ceph-admin ~]$ ceph -s
cluster 15ddcfcd-c993-4704-a141-4c4bb3c9b2b8
 health HEALTH_OK
 monmap e1: 3 mons at {ceph-admin=172.1.72.10:6789/0,ceph-node-1=172.1.72.11:6789/0,ceph-node-2=172.1.72.12:6789/0}
        election epoch 6, quorum 0,1,2 ceph-admin,ceph-node-1,ceph-node-2
 osdmap e20: 2 osds: 2 up, 2 in
        flags sortbitwise,require_jewel_osds
  pgmap v83: 112 pgs, 7 pools, 1588 bytes data, 171 objects
        12965 MB used, 63733 MB / 76698 MB avail
             112 active+clean
[vagrant@ceph-admin ~]$ 
[vagrant@ceph-admin ~]$ 
[vagrant@ceph-admin ~]$ sudo netstat -tpln | grep -E "(ceph*|radosgw)"
tcp        0      0 0.0.0.0:7480            0.0.0.0:*               LISTEN      5522/radosgw        
tcp        0      0 172.1.72.10:6789        0.0.0.0:*               LISTEN      4769/ceph-mon
```

* ceph-server

```bash
$ vagrant ssh ceph-server-1
[vagrant@ceph-server-1 ~]$ ceph -s
[vagrant@ceph-server-1 ~]$ 
[vagrant@ceph-server-1 ~]$ sudo netstat -tpln | grep ceph*
tcp        0      0 0.0.0.0:6800            0.0.0.0:*               LISTEN      5574/ceph-osd       
tcp        0      0 0.0.0.0:6801            0.0.0.0:*               LISTEN      5574/ceph-osd       
tcp        0      0 0.0.0.0:6802            0.0.0.0:*               LISTEN      5574/ceph-osd       
tcp        0      0 0.0.0.0:6803            0.0.0.0:*               LISTEN      5574/ceph-osd       
tcp        0      0 172.1.72.11:6789        0.0.0.0:*               LISTEN      4957/ceph-mon 
```


## �ο�

  * [codedellemc/vagrant - GitHub](https://github.com/codedellemc/vagrant/tree/master/ceph)
  * [Multinode Ceph on Vagrant](https://github.com/carmstrong/multinode-ceph-vagrant)