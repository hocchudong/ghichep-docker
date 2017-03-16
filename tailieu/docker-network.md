#Network trong Docker.
![](https://camo.githubusercontent.com/d2c856d1986260ace4a29c8478e17bba09dacc13/687474703a2f2f692e696d6775722e636f6d2f614e534a3639792e706e67)

Khi chúng ta cài đặt Docker, những thiết lập sau sẽ được thực hiện:
  - Virtual bridge docker0 sẽ được tạo ra
  - Docker tìm một subnet chưa được dùng trên host và gán một địa chỉ cho docker0

Sau đó, khi chúng ta khởi động một container (với bridge network), một veth (Virtual Ethernet) sẽ được tạo ra nối 1 đầu với docker0 và một đầu sẽ được nối với interface eth0 trên container.

#1. Default network
Mặc định khi cài đặt xong, Docker sẽ tạo ra 3 card mạng mặc định là:
- bridge
- host
- only.

Để xem chi tiết, ta có thể dùng lệnh
```sh
docker network ls
```

```sh
root@adk:/# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
1d8aa8d520a2        bridge              bridge              local
a8ddedeecca8        host                host                local
ad1c5f949ef2        none                null                local
root@adk:/# 
```

Mặc định khi tạo container mà ta không chỉ định dùng network nào, thì docker sẽ dùng dải bridge.

##1.1 None network
Các container thiết lập network này sẽ không được cấu hình mạng. 

##1.2 Bridge
Docker sẽ tạo ra một switch ảo. Khi container được tạo ra, interface của container sẽ gắn vào switch ảo này và kết nối với interface của host.

```sh
root@adk:~# docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "1d8aa8d520a2775b5f02279e2ff057e2d781a67e116e603d367edab58211a5d9",
        "Created": "2017-03-14T09:35:39.561628223+07:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Containers": {},
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
root@adk:~# 
```

##1.3 Host
Containers sẽ dùng mạng trực tiếp của máy host. Network configuration bên trong container đồng nhất với host.

##2. User-defined networks
Ngoài việc sử dụng các network mặc định do docker cung cấp. Ta có thể tự định nghĩa ra các dải network phù hợp
với công việc của mình.

Để tạo network, ta dùng lệnh
```sh
docker network create --driver bridge --subnet 192.168.1.0/24 bridgexxx
```
Trong đó:
- **--driver bridge**: Chỉ định dải mạng mới được tạo ra sẽ thuộc kiểu nào: bridge, host, hay none.
- **--subnet**: Chỉ định địa địa chỉ mạng.
- **bridgexxx**: Tên của dải mạng mới.

Khi chạy container chỉ định sử dụng 1 dải mạng đặc biệt, ta dùng lệnh
```sh
docker run --network=bridgexxx -itd --name=container3 busybox
```
Trong đó:
  - **--network=bridgexxx:** Chỉ định ra dải mạng bridgexxx sẽ kết nối với container.

Container mà bạn chạy trên network này đều phải thuộc về cùng một Docker host. Mỗi container trong network có thể communicate với các containers khác trong cùng network.

##3. An overlay network with Docker Engine swarm mode
- Overlay network là mạng có thể kết nối nhiều container trên các **Docker Engine** lại với nhau, trong môi trường cluster.
- Swarm tạo ra overlay network chỉ available với các nodes bên trong swarm. Khi bạn tạo ra một service sử dụng overlay network, manager node sẽ tự động kế thừa overlay network tới các nodes chạy các service tasks.

Ví dụ sau sẽ hướng dẫn cách tạo ra một network và sử dụng nó cho một service từ một manager node bên trong swarm:
```sh
# Create an overlay network `my-multi-host-network`.
$ docker network create \
  --driver overlay \
  --subnet 10.0.9.0/24 \
  my-multi-host-network

400g6bwzd68jizzdx5pgyoe95

# Create an nginx service and extend the my-multi-host-network to nodes where
# the service's tasks run.
$ $ docker service create --replicas 2 --network my-multi-host-network --name my-web nginx

716thylsndqma81j6kkkb5aus
```

#Ref
- http://www.dasblinkenlichten.com/docker-networking-101-host-mode/
- https://viblo.asia/euclid/posts/XqakEmmbkWK
- https://docs.docker.com/engine/userguide/networking/#the-dockergwbridge-network