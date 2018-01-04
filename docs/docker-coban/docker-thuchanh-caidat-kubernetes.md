# Hướng dẫn cài đặt Kubernetes
## Môi trường LAB
- 03 node cài CentOS7: 01 node admin và 02 node container
### Mô hình

### Phân hoạch IP


## Setup hostname và IP theo phân hoạch ip

### Thiết lập trên node admin

- Khai báo hostname

```sh
hostnamectl set-hostname adminnode
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


### Thiết lập trên node container1

- Khai báo hostname

```sh
hostnamectl set-hostname container1node
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

### Thiết lập trên node container2

- Khai báo hostname

```sh
hostnamectl set-hostname container2node
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

## Cài đăt Kubernetes

### Cài đặt trên node admin

- Cài đặt gói cần thiết cho node admin

  ```sh
  yum -y install kubernetes etcd flannel
  ```

- Tạo key

  ```sh
  openssl genrsa -out /etc/kubernetes/service.key 2048
  ```

- Sửa file `/etc/kubernetes/controller-manager`

  ```sh
  sed -i 's/KUBE_CONTROLLER_MANAGER_ARGS/#KUBE_CONTROLLER_MANAGER_ARGS/g' /etc/kubernetes/controller-manager
  echo 'KUBE_CONTROLLER_MANAGER_ARGS="--service_account_private_key_file=/etc/kubernetes/service.key"' >>  /etc/kubernetes/controller-manager
  ```

- Sửa file `/etc/kubernetes/apiserver`

```sh
sed -i 's/--insecure-bind-address=127.0.0.1/--address=0.0.0.0/g' /etc/kubernetes/apiserver
sed -i 's/127.0.0.1:2379/172.16.68.221:2379/g' /etc/kubernetes/apiserver
sed -i 's/KUBE_API_ARGS/#KUBE_API_ARGS/g' /etc/kubernetes/apiserver
echo 'KUBE_API_ARGS="--service_account_key_file=/etc/kubernetes/service.key"' >> /etc/kubernetes/apiserver
```

- Sửa file `/etc/etcd/etcd.conf`

```sh
sed -i 's/#ETCD_LISTEN_PEER_URLS/ETCD_LISTEN_PEER_URLS/g' /etc/etcd/etcd.conf
sed -i 's/ETCD_LISTEN_CLIENT_URLS/#ETCD_LISTEN_CLIENT_URLS/g' /etc/etcd/etcd.conf
echo 'ETCD_LISTEN_CLIENT_URLS="http://172.16.68.221:2379,http://localhost:2379"' >> /etc/etcd/etcd.conf
```

- Sửa file `/etc/kubernetes/config`

  ```sh
  sed -i 's/127.0.0.1/172.16.68.221/g' /etc/kubernetes/config
  ```

- Khởi động và kích hoạt kubernetes

  ```sh
  systemctl start etcd kube-apiserver kube-controller-manager kube-scheduler
  systemctl enable etcd kube-apiserver kube-controller-manager kube-scheduler
  ```

- Tạo file `flannel-config.json` với nội dung dưới

  ```sh
  cat <<EOF> flannel-config.json
  {
    "Network":"172.16.0.0/16",
    "SubnetLen":24,
    "Backend":{
      "Type":"vxlan",
      "VNI":1
    }
  }
  EOF
  ```

- Sửa file `/etc/sysconfig/flanneld`

  ```sh
  sed -i 's/127.0.0.1/172.16.68.221/g' /etc/sysconfig/flanneld
  ```

- Khai báo cấu hình cho flanneld

  ```sh
  etcdctl set atomic.io/network/config < flannel-config.json 
  ```
  
- Khởi động flanneld

```sh
systemctl start flanneld 
systemctl enable flanneld 
```

- Kiểm tra hoạt động trên node master bằng lệnh `kubectl cluster-info`, kết quả như sau:

  ```sh
  [root@masternode ~]# kubectl cluster-info
  Kubernetes master is running at http://localhost:8080

  To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
  [root@masternode ~]#
  ```

### Cấu hình kubernetes trên các node container
- Thực hiện trên tất cả các node container

```sh
yum -y install kubernetes flannel
```

- Sửa cấu hình của file `/etc/kubernetes/config` trên node container1

```sh
sed -i 's/127.0.0.1/172.16.68.221/g' /etc/kubernetes/config
```

- Sửa cấu hình file `/etc/kubernetes/kubelet`. Lưu ý: nhập đúng hostname đặt ở trên.

  ```sh
  sed -i 's/--address=127.0.0.1/--address=0.0.0.0/g' /etc/kubernetes/kubelet
  sed -i 's/--hostname-override=127.0.0.1/--hostname_override=container1node/g' /etc/kubernetes/kubelet
  sed -i 's/127.0.0.1:8080/172.16.68.221:8080/g' /etc/kubernetes/kubelet
  ```

- Sửa file `/etc/sysconfig/flanneld`

  ```sh
  sed -i 's/127.0.0.1/172.16.68.221/g' /etc/sysconfig/flanneld
  ```

- Khởi động các dịch vụ của kubernetes trên node container1node

```sh
systemctl start flanneld kube-proxy kubelet 
systemctl enable flanneld kube-proxy kubelet
systemctl restart docker 
```

- Xóa docker0 network

```sh
sudo systemctl disable network
sudo systemctl stop network
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

nmcli c down docker0 

sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network
```

- Sửa cấu hình của file `/etc/kubernetes/config` trên node container2

```sh
sed -i 's/127.0.0.1/172.16.68.221/g' /etc/kubernetes/config
```

- Sửa cấu hình file `/etc/kubernetes/kubelet`. Lưu ý: nhập đúng hostname đặt ở trên.

  ```sh
  sed -i 's/--address=127.0.0.1/--address=0.0.0.0/g' /etc/kubernetes/kubelet
  sed -i 's/--hostname-override=127.0.0.1/--hostname_override=container2node/g' /etc/kubernetes/kubelet
  sed -i 's/127.0.0.1:8080/172.16.68.221:8080/g' /etc/kubernetes/kubelet
  ```

- Sửa file `/etc/sysconfig/flanneld`

  ```sh
  sed -i 's/127.0.0.1/172.16.68.221/g' /etc/sysconfig/flanneld
  ```

- Khởi động các dịch vụ của kubernetes trên node container1node

  ```sh
  systemctl start flanneld kube-proxy kubelet 
  systemctl enable flanneld kube-proxy kubelet
  systemctl restart docker 
  ```

- Xóa docker0 network

  ```sh
  sudo systemctl disable network
  sudo systemctl stop network
  sudo systemctl enable NetworkManager
  sudo systemctl start NetworkManager

  nmcli c down docker0 

  sudo systemctl disable NetworkManager
  sudo systemctl stop NetworkManager
  sudo systemctl enable network
  sudo systemctl start network
  ```

- Kiểm tra hoạt độn của kubernetes trên node master bằng lệnh `kubectl get nodes`, kết quả như bên dưới là ok. Chưa ok thì kiểm tra lại từ đầu tới cuối :) 

  ```sh
  [root@masternode ~]# kubectl get nodes
  NAME             STATUS    AGE
  container1node   Ready     7m
  container2node   Ready     1m
  [root@masternode ~]#
  ```

### Tạo Pods

- Đứng trên node container1, thực hiện tạo images từ dockerfile.
- Soạn docker file 
  ```sh
  cat <<EOF> /root/Dockerfile

  FROM centos
  MAINTAINER hocchudong <admin@hocchudong.com>
  RUN yum -y install httpd
  RUN echo "Hello hocchudong" > /var/www/html/index.html
  EXPOSE 80
  CMD ["-D", "FOREGROUND"]
  ENTRYPOINT ["/usr/sbin/httpd"]
  EOF 
  ```

- Tạo images từ dockerfile vừa tạo ở trên (đứng trên container1node). tên của images là `web_server`

  ```sh
  docker build -t web_server:latest .
  ```

- Có thể kiểm tra xem images tạo thành công hay chưa bằng lệnh `docker images`

- Save image có tên là `web_server` ở trên container1node.

  ```sh
  docker save web_server > web_server.tar
  ```

- Copy sang container2node. File copy này có dung lượng khoảng 300Mb, khi yêu cầu mật khẩu thì hãy nhập mật khẩu của tài khoản `root` của node container2node.
 
  ```sh
  scp web_server.tar node02:/root/web_server.tar 
  ```
  
- Sang node container2node, thực hiện import images vừa được copy và thực hiện kiểm tra.

```sh
docker load < web_server.tar

docker images
```

  - Kết quả như sau: 
  
    ```sh
    [root@container2node ~]# docker load < web_server.tar
    cf516324493c: Loading layer [==================================================>] 205.2 MB/205.2 MB
    4615d7a81106: Loading layer [==================================================>] 113.4 MB/113.4 MB
    7917e6791576: Loading layer [==================================================>] 3.584 kB/3.584 kB
    Loaded image: web_server:latest
    [root@container2node ~]# docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    web_server          latest              9d9ced141680        6 minutes ago       309.3 MB
    [root@container2node ~]#
    ```

    
#### Tạo Pods trên node master.
- Đứng trên master và soạn file `pod-webserver.yaml` dưới.


  ```sh
  cat <<EOF> pod-webserver.yaml
  apiVersion: v1
  kind: Pod
  metadata:
    # name of Pod
    name: httpd
    labels:
      # rabel of Pod
      app: web_server
  spec:
    containers:
      # name of Container
    - name: httpd
      # Container image
      image: web_server
      ports:
        # Container Port
      - containerPort: 80
  EOF
  ```

- Lưu ý: Đây là file yaml nên thò thụt phải chuẩn nhé.
- Thực hiện tạo pods

```sh
kubectl create -f pod-webserver.yaml 
```