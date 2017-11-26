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

- Phân quyền cho user để sử dụng docker 

```sh
sudo usermod -aG docker `whoami`
```

- Khởi động docker engine

```sh
systemctl start docker.service
systemctl enable docker.service
```

- Kiểm tra phiên bản của docker engine

```sh
docker version
```

- Kiểm tra hoạt động của docker engine sau khi cài 

```sh
systemctl status docker.service
```

- Disable live-store trên cả 03 node (vì docker swarm không dùng tùy chọn này). Soạn file `/etc/docker/daemon.json` với nội dung dưới

```sh
cat <<EOF> /etc/docker/daemon.json
{
    "live-restore": false
}
EOF
```

- Khởi động lại docker engine 

```sh
systemctl restart docker 
```

### Cấu hình docker swarm
- Đứng trên node master thực hiện lệnh dưới để thiết lập docker swarm

```sh
docker swarm init --advertise-addr eth1
```
- Trong đó:
  - Nếu có nhiều NICs thì cần chỉ định thêm tùy chọn `--advertise-addr` để chỉ ra tên của interfaces mà docker swarm sẽ dùng, các node worker sẽ dùng IP này để join vào cluster.

- Kết quả của lệnh trên như bên dưới, lưu ý dòng thông báo trong kết quả nhé. Dòng này để sử dụng trên các node worker.

```sh
[root@masternode ~]# docker swarm init --advertise-addr eth1
Swarm initialized: current node (yio0waboc34i8xqh86zt2rdat) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-1w88l3qp3q5312lvf6nvkscuky03f99iwd4u6wighokzy4xomf-1io10gmxni8pmdajsof1gqy41 172.16.68.221:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[root@masternode ~]#
```

  
- Đứng trên node `worker1` và `worker2` để join vào node master. Thực hiện cả trên 02 node worker còn lại.

```sh
docker swarm join --token SWMTKN-1-1w88l3qp3q5312lvf6nvkscuky03f99iwd4u6wighokzy4xomf-1io10gmxni8pmdajsof1gqy41 172.16.68.221:2377
```


