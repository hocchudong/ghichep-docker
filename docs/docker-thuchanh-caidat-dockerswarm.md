# Hướng dẫn cài đặt Docker Swarm
## Môi trường LAB
- 03 node cài CentOS7: 01 node master và 02 node worker
### Mô hình

### Phân hoạch IP


## Setup hostname và IP theo phân hoạch ip

### Thiết lập trên node master

- Khai báo hostname

```sh
hostnamectl set-hostname masternode
```

- Khai báo IP và các setup cơ bản

```sh

echo "Setup IP  eth0"
nmcli c modify eth0 ipv4.addresses 10.10.10.221/24
nmcli c modify eth0 ipv4.method manual
nmcli con mod eth0 connection.autoconnect yes

echo "Setup IP  eth1"
nmcli c modify eth1 ipv4.addresses 172.16.68.221/24
nmcli c modify eth1 ipv4.gateway 172.16.68.1
nmcli c modify eth1 ipv4.dns 8.8.8.8
nmcli c modify eth1 ipv4.method manual
nmcli con mod eth1 connection.autoconnect yes


echo "Setup IP  eth2"
nmcli c modify eth2 ipv4.addresses 10.10.20.221/24
nmcli c modify eth2 ipv4.method manual
nmcli con mod eth2 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```


### Thiết lập trên node worker1

- Khai báo hostname

```sh
hostnamectl set-hostname worker1node
```

- Khai báo IP và các setup cơ bản

```sh
echo "Setup IP  eth0"
nmcli c modify eth0 ipv4.addresses 10.10.10.222/24
nmcli c modify eth0 ipv4.method manual
nmcli con mod eth0 connection.autoconnect yes

echo "Setup IP  eth1"
nmcli c modify eth1 ipv4.addresses 172.16.68.222/24
nmcli c modify eth1 ipv4.gateway 172.16.68.1
nmcli c modify eth1 ipv4.dns 8.8.8.8
nmcli c modify eth1 ipv4.method manual
nmcli con mod eth1 connection.autoconnect yes


echo "Setup IP  eth2"
nmcli c modify eth2 ipv4.addresses 10.10.20.222/24
nmcli c modify eth2 ipv4.method manual
nmcli con mod eth2 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```



### Thiết lập trên node worker2

- Khai báo hostname

```sh
hostnamectl set-hostname worker2node
```

- Khai báo IP và các setup cơ bản

```sh
echo "Setup IP  eth0"
nmcli c modify eth0 ipv4.addresses 10.10.10.223/24
nmcli c modify eth0 ipv4.method manual
nmcli con mod eth0 connection.autoconnect yes

echo "Setup IP  eth1"
nmcli c modify eth1 ipv4.addresses 172.16.68.223/24
nmcli c modify eth1 ipv4.gateway 172.16.68.1
nmcli c modify eth1 ipv4.dns 8.8.8.8
nmcli c modify eth1 ipv4.method manual
nmcli con mod eth1 connection.autoconnect yes


echo "Setup IP  eth2"
nmcli c modify eth2 ipv4.addresses 10.10.20.223/24
nmcli c modify eth2 ipv4.method manual
nmcli con mod eth2 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

## Cài đăt docker engine và cấu hình docker swarm

### Cài đặt docker trên 03 node

- Cài đặt docker engine và chuẩn bị để sẵn sàng cấu hình docker swarm trên cả 03 node.

```sh
su - 

curl -sSL https://get.docker.com/ | sudo sh
```



