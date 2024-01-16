# NDB Cluster
MySQL 서버의 고가용성 및 확장성 제공을 위한 클러스터링 솔루션
데이터를 여러 Datanode 서버에 분산, node 간의 데이터 공유


# Settings
reference: https://medium.com/@umairhassan27/setting-up-a-mysql-ndb-cluster-step-by-step-guide-b7310492ef60
<br>

### environment
``` shell
ubuntu 22.04 LTS
```
<br>

### Servers
``` shell
sudo apt install -y libclass-methodmaker-perl
sudo apt install -y libaio1 libmecab2

```

``` shell
$ wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.3/mysql-cluster-community-client_8.3.0-1ubuntu22.04_amd64.deb
$ wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.3/mysql-cluster-community-server-core_8.3.0-1ubuntu22.04_amd64.deb
$ wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.3/mysql-cluster-community-data-node_8.3.0-1ubuntu22.04_amd64.deb
$ wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.3/mysql-common_8.3.0-1ubuntu22.04_amd64.deb
$ wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.3/mysql-cluster-community-server_8.3.0-1ubuntu22.04_amd64.deb
$ wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.3/mysql-cluster-community-client-core_8.3.0-1ubuntu22.04_amd64.deb
$ wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.3/mysql-client_8.3.0-1ubuntu22.04_amd64.deb
$ wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.3/mysql-server_8.3.0-1ubuntu22.04_amd64.deb
$ dpkg -i *.deb
```
<br>

``` shell
$ mkdir -p /var/lib/mysql/
$ chown -R mysql:mysql /var/lib/mysql/
```
<br>

``` shell
$ vi /etc/systemd/system/ndbd.service
```
```
[Unit]
Description=MySQL NDB Data Node Daemon
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/ndbd
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
<br>

``` shell
$ systemctl enable ndbd
```
<br>

``` shell
$ vim /etc/mysql/my.cnf
```
```
 [mysqld]
 ndbcluster
 ndb-connectstring=192.168.221.132 #IP of Managament Node

 [mysql_cluster]
 ndb-connectstring=192.168.221.132 #IP of Managament Node
```
<br>

### management node
``` shell
$ wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.3/mysql-cluster-community-management-server_8.3.0-1ubuntu22.04_amd64.deb
$ dpkg -i mysql-cluster-community-management-server_8.3.0-1ubuntu22.04_amd64.deb
```
<br>

``` shell
$ mkdir -p /usr/mysql-cluster
```
<br>

``` shell
$ vim /usr/mysql-cluster/config.ini
```
``` 
[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=2  # Number of replicas

[ndb_mgmd]
# Management process options:
hostname=192.168.221.132  # Hostname of the Management NOde
datadir=/usr/mysql-cluster  # Directory for the log files

[ndbd]
hostname=192.168.221.133  # Hostname/IP of the first data node
NodeId=2  # Node ID for this data node
datadir=/var/lib/mysql/  # Remote directory for the data files

[ndbd]
hostname=192.168.221.134  # Hostname/IP of the second data node
NodeId=3  # Node ID for this data node
datadir=/var/lib/mysql/  # Remote directory for the data files

[mysqld]
NodeId=4
hostname=192.168.221.133 #SQL Node 1

[mysqld]
NodeId=5
hostname=192.168.221.134 #SQL Node 2
```
<br>

``` shell
$ vi /etc/systemd/system/ndb_mgmd.service
```
```
[Unit]
Description=MySQL NDB Cluster Management Server
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/ndb_mgmd -f /usr/mysql-cluster/config.ini
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
```
<br>

``` shell
$ systemctl enable ndb_mgmd
$ systemctl daemon-reload
```
<br>

``` shell
$ ndb_mgmd --initial --config-file=/usr/mysql-cluster/config.ini
```
<br>

### Test at Datanodes
``` shell
$ NDBD

2023-02-16 04:28:00 [ndbd] INFO     -- Angel connected to '192.168.221.132:1186'
2023-02-16 04:28:00 [ndbd] INFO     -- Angel allocated nodeid: 2
```
<br>

``` shell
$ Service mysql start
```
<br>

### Test at Management Node
``` shell
$ ndb_mgm -e show

Connected to Management Server at: 192.168.221.132:1186
Cluster Configuration
---------------------
[ndbd(NDB)]     2 node(s)
id=2    @192.168.221.133  (mysql-8.0.19 ndb-8.0.19, Nodegroup: 0, *)
id=3    @192.168.221.134  (mysql-8.0.19 ndb-8.0.19, Nodegroup: 0)

[ndb_mgmd(MGM)] 1 node(s)
id=1    @192.168.221.132  (mysql-8.0.19 ndb-8.0.19)

[mysqld(API)]   2 node(s)
id=4    @192.168.221.133  (mysql-8.0.19 ndb-8.0.19)
id=5    @192.168.221.134  (mysql-8.0.19 ndb-8.0.19)
```
