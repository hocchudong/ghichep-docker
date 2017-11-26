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

- Kết quả sẽ có thông báo như sau: 

  ```sh
  [root@worker1node ~]# docker swarm join --token SWMTKN-1-1w88l3qp3q5312lvf6nvkscuky03f99iwd4u6wighokzy4xomf-1io10gmxni8pmdajsof1gqy41 172.16.68.221:2377
  This node joined a swarm as a worker.
  ```
  
- Đứng trên node master thực hiện lệnh `docker node ls` để kiểm tra xem các node worker đã join hay chưa. Nếu chưa ổn thì kiểm tra kỹ lại các bước ở trên.

  ```sh
  docker node ls
  ```
  
  - Kết quả

    ```sh
    [root@masternode ~]# docker node ls
    ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
    yio0waboc34i8xqh86zt2rdat *   masternode          Ready               Active              Leader
    oh19lt8vnic067jep1ro8nw3r     worker1node         Ready               Active
    kesl0xhuj9w6yl84og4x2sd3y     worker2node         Ready               Active
    [root@masternode ~]#
    ```
    
### Kiểm tra hoạt động của cụm docker swarm vừa dựng.

- Tạo file `Dockerfile` với nội dung bên dưới trên tất cả các node. Ở đây tôi sẽ tạo ra một images chạy web server, lưu ý, tôi sẽ tạo các nội dung các web server khác nhau với 03 node để khi kiểm tra sẽ thấy các kết quả của container trên từng node.

- Trên node master

  ```sh
  cat <<EOF> /root/Dockerfile
  FROM centos
  MAINTAINER hocchudong <admin@hocchudong.com>
  RUN yum -y install httpd
  RUN echo "Node master Hello DockerFile" > /var/www/html/index.html
  EXPOSE 80
  CMD ["-D", "FOREGROUND"]
  ENTRYPOINT ["/usr/sbin/httpd"]
  EOF
  ```

- Trên node worker1

  ```sh
  cat <<EOF> /root/Dockerfile
  FROM centos
  MAINTAINER hocchudong <admin@hocchudong.com>
  RUN yum -y install httpd
  RUN echo "Node worker1 Hello DockerFile" > /var/www/html/index.html
  EXPOSE 80
  CMD ["-D", "FOREGROUND"]
  ENTRYPOINT ["/usr/sbin/httpd"]
  EOF
  ```
  
- Trên node worker2

  ```sh
  cat <<EOF> /root/Dockerfile
  FROM centos
  MAINTAINER hocchudong <admin@hocchudong.com>
  RUN yum -y install httpd
  RUN echo "Node worker2 Hello DockerFile" > /var/www/html/index.html
  EXPOSE 80
  CMD ["-D", "FOREGROUND"]
  ENTRYPOINT ["/usr/sbin/httpd"]
  EOF
  ```

  
- Thực hiện build image với dockerfile vừa tạo ở trên trên cả 03 node (lưu ý dấu . nhé, lúc này đang đứng tại thư mục `root`)

  ```sh
  docker build -t web_server:latest . 
  ```
  
- Kiểm tra images sau khi build xong dockerfile ở trên

  ```sh
  docker images
  ```
  - Kết quả:
  
    ```sh
    Complete!
    Removing intermediate container ac34ac2bf2bf
     ---> 1f52eba3ee41
    Step 4/7 : RUN echo "Hello DockerFile" > /var/www/html/index.html
     ---> Running in 1100a7cddd06
    Removing intermediate container 1100a7cddd06
     ---> cdd86cafcdc8
    Step 5/7 : EXPOSE 80
     ---> Running in 262d31a60118
    Removing intermediate container 262d31a60118
     ---> d0ecbae79e34
    Step 6/7 : CMD ["-D", "FOREGROUND"]
     ---> Running in e9af0ad1d386
    Removing intermediate container e9af0ad1d386
     ---> 5a9e18361f4d
    Step 7/7 : ENTRYPOINT ["/usr/sbin/httpd"]
     ---> Running in c95a17b69cb6
    Removing intermediate container c95a17b69cb6
     ---> bbc76a4873a4
    Successfully built bbc76a4873a4
    Successfully tagged web_server:latest
    ```
  
- Tạo container từ image ở trên với số lượng bản sao là 02.

  ```sh
  docker service create --name swarm_cluster --replicas=2 -p 80:80 web_server:latest 
  ```

  - Kết quả như sau:
    
    ```sh
    [root@masternode ~]# docker service create --name swarm_cluster --replicas=2 -p 80:80 web_server:latest
    image web_server:latest could not be accessed on a registry to record
    its digest. Each node will access web_server:latest independently,
    possibly leading to different nodes running different
    versions of the image.

    6ygnj41a2z5ulocq0m6p897e6
    overall progress: 2 out of 2 tasks
    1/2: running   [==================================================>]
    2/2: running   [==================================================>]
    verify: Service converged
    ```

- Kiểm tra lại kết quả bằng lệnh `docker service ls` 

  ```sh
  [root@masternode ~]# docker service ls
  ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
  6ygnj41a2z5u        swarm_cluster       replicated          2/2                 web_server:latest   *:80->80/tcp
  ```

- Kiểm tra sâu hơn bên trong của cluster 

  ```sh
  docker service inspect swarm_cluster --pretty 
  ```
  
  - Kết quả
  
    ```sh
    [root@masternode ~]# docker service inspect swarm_cluster --pretty

    ID:             6ygnj41a2z5ulocq0m6p897e6
    Name:           swarm_cluster
    Service Mode:   Replicated
    Replicas:      2
    Placement:
    UpdateConfig:
    Parallelism:   1
    On failure:    pause
    Monitoring Period: 5s
    Max failure ratio: 0
    Update order:      stop-first
    RollbackConfig:
    Parallelism:   1
    On failure:    pause
    Monitoring Period: 5s
    Max failure ratio: 0
    Rollback order:    stop-first
    ContainerSpec:
    Image:         web_server:latest
    Resources:
    Endpoint Mode:  vip
    Ports:
    PublishedPort = 80
    Protocol = tcp
    TargetPort = 80
    PublishMode = ingress
    ```

- Kiểm tra trạng thái của các service bằng lệnh `docker service ps swarm_cluster`,kết quả như bên dưới.

  ```sh
  [root@masternode ~]# docker service ps swarm_cluster
  ID                  NAME                  IMAGE               NODE                DESIRED STATE       CURRENT STATE             ERROR                              PORTS
  qr3sk06m5j6p        swarm_cluster.1       web_server:latest   masternode          Running             Running 14 minutes ago
  ernkqk5fnsoe        swarm_cluster.2       web_server:latest   masternode          Running             Running 13 minutes ago
  t0zyoiiyvbqm         \_ swarm_cluster.2   web_server:latest   worker2node         Shutdown            Rejected 14 minutes ago   "No such image: web_server:lat…"
  zhvl18ca2dgs         \_ swarm_cluster.2   web_server:latest   worker2node         Shutdown            Rejected 14 minutes ago   "No such image: web_server:lat…"
  pe25zymjbk87         \_ swarm_cluster.2   web_server:latest   worker1node         Shutdown            Rejected 14 minutes ago   "No such image: web_server:lat…"
  odyy3eryolgf         \_ swarm_cluster.2   web_server:latest   worker1node         Shutdown            Rejected 14 minutes ago   "No such image: web_server:lat…"
  [root@masternode ~]#
  ```

-