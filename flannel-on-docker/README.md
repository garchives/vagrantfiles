# Flannel On Docker

所有的包都是通过 yum 命令来安装的，所以有的包可能比较旧。

## 系统环境

  * Centos 7.3.1611
  * Kernel 3.10.0-514.26.2
  * Docker 1.12.6
  * Etcd 2.3.7
  * Flannel 0.7.1-1


## 集群分布

| role                | hostname         | ip          |
| ------------------- | ---------------- | ----------- |
| flannel docker etcd | centos-flannel-1 | 172.72.2.11 |
| flannel docker      | centos-flannel-2 | 172.72.2.12 |
| flannel docker      | centos-flannel-3 | 172.72.2.13 |


## 部署

```bash
$ # 启动虚拟机并自动部署 flannel 网络
$ vagrant up
$
$ # 如果是重启可以不执行 provision，也就是不用再执行部署脚本
$ vagrant reload --no-provision
```

```bash
$ # 更新虚拟机与宿主机的 hosts 文件，可以直接通过主机名来访问
$ # 需要先安装 hostmanager 插件： vagrant plugin install vagrant-hostmanager
$ vagrant hostmanager
```


## 检验

* 检查 etcd 是否健康

```bash
$ vagrant ssh centos-flannel-1
[vagrant@centos-flannel-1 ~]$ # 查看配置
[vagrant@centos-flannel-1 ~]$ etcdctl get /flannel/network/config
[vagrant@centos-flannel-1 ~]$ 
[vagrant@centos-flannel-1 ~]$ # 查看集群是否健康
[vagrant@centos-flannel-1 ~]$ etcdctl cluster-health
```

* 检查 docker0 与 flannel.1 是否在同一虚拟网络

默认的虚拟网络为 `10.20.0.0/16`，子网长度为 `24`。

```bash
$ vagrant ssh centos-flannel-x
[vagrant@centos-flannel-x ~]$ ifconfig docker0 | grep inet
        inet 10.20.36.1  netmask 255.255.255.0  broadcast 0.0.0.0
[vagrant@centos-flannel-x ~]$     
[vagrant@centos-flannel-x ~]$ ifconfig flannel.1 | grep inet
        inet 10.20.36.0  netmask 255.255.255.255  broadcast 0.0.0.0 
```


## 注意事项

1. 安装部署好 flannel　后， `flannel-deploy.sh` 会对配置文件 `/etc/sysconfig/flanneld` 加以修改来指定正确的网络接口和 etcd　服务器。

2. 安装部署好 flannel　后，不需要修改 docker 配置，不过需要重启

启动 flannel 后，会在 `/run/flannel/docker` 文件中自动添加一些由 Docker daemon 的参数所组成的环境变量。Docker daemon 的 `--bip` 参数表示 bridge ip，也就是网桥　docker0 的　IP 地址。

```bash
$ cat /run/flannel/docker
DOCKER_OPT_BIP="--bip=10.20.2.1/24"
DOCKER_OPT_IPMASQ="--ip-masq=true"
DOCKER_OPT_MTU="--mtu=1450"
DOCKER_NETWORK_OPTIONS=" --bip=10.20.2.1/24 --ip-masq=true --mtu=1450"
```

查看 docker.service 发现它自动引入了上面的配置文件，所以不用再手动修改 docker.service 或者 Docker 环境变量（`/etc/sysconfig/docker`、`/etc/sysconfig/docker-network`等）。

```bash
$ systemctl cat docker.service
...
# /usr/lib/systemd/system/docker.service.d/flannel.conf
[Service]
EnvironmentFile=-/run/flannel/docker
```

应该是下面这行代码，使 docker.service 自动引入了 `/run/flannel/docker` 这个配置文件。

```bash
$ systemctl cat flanneld.service | grep ExecStartPost
ExecStartPost=/usr/libexec/flannel/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker