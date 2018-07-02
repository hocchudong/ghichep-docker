# Network trong Docker.

![](https://camo.githubusercontent.com/d2c856d1986260ace4a29c8478e17bba09dacc13/687474703a2f2f692e696d6775722e636f6d2f614e534a3639792e706e67)

Khi chúng ta cài đặt Docker, những thiết lập sau sẽ được thực hiện:
  - Virtual bridge docker0 sẽ được tạo ra
  - Docker tìm một subnet chưa được dùng trên host và gán một địa chỉ cho docker0

Sau đó, khi chúng ta khởi động một container (với bridge network), một veth (Virtual Ethernet) sẽ được tạo ra nối 1 đầu với docker0 và một đầu sẽ được nối với interface eth0 trên container.

# 1. Default network
Mặc định khi cài đặt xong, Docker sẽ tạo ra 3 card mạng mặc định là:
- bridge
- host
- only.

- Tương ứng với các nền tảo ảo hóa khác, ta có các chế độ card mạng của docker so với các nền tảng đấy là:

| General Virtualization Term | Docker Network Driver                            |
|-----------------------------|--------------------------------------------------|
| NAT Network                 | bridge                                           |
| Bridged                     | macvlan, ipvlan (experimental since Docker 1.11) |
| Private / Host-only         | bridge                                           |
| Overlay Network / VXLAN     | overlay                                          |



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

## 1.1 None network
Các container thiết lập network này sẽ không được cấu hình mạng. 

## 1.2 Bridge
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

## 1.3 Host
Containers sẽ dùng mạng trực tiếp của máy host. Network configuration bên trong container đồng nhất với host.

## 2. User-defined networks
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

## 3. An overlay network with Docker Engine swarm mode
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

# 4. "Nói chuyện" giữa các container với nhau.

- Trên cùng một host, các container chỉ cần dùng bridge network để nói chuyện được với nhau. Tuy nhiên, các container được cấp ip động nên nó có thể thay đổi, dẫn đến nhiều khó khăn. Vì vậy, thay vì dùng địa chỉ ip, ta có thể dùng name của các container để "liên lạc" giữa các container với nhau.
- Trong trường hợp sử dụng default bridge network thì ta khai báo thêm lệnh `--link=name_container`.
- Trong trường hợp sử dụng user-defined bridge network thì ta không cần phải link nữa.

## 4.1 Trường hợp sử dụng default bridge network để kết nối các container

- Giả sử ta có mô hình: `web - db`
- container web phải link được với container db. 

```sh
docker run -itd --name=db -e MYSQL_ROOT_PASSWORD=pass mysql:latest
docker run -itd --name=web --link=db nginx:latest
```

- Kiểm tra: 
```sh
docker exec -it web sh
# ping redis
PING redis (172.17.0.3): 56 data bytes
64 bytes from 172.17.0.3: icmp_seq=0 ttl=64 time=0.245 ms
...
# ping db
PING db (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: icmp_seq=0 ttl=64 time=0.126 ms
...
```

## 4.2 Trường hợp sử dụng user-defined bridge network để kết nối các container

- Bạn không cần thực hiện thao tác link qua link lại giữa các container nữa.

```sh
docker network create my-net
docker network ls
NETWORK ID          NAME                DRIVER
716f591e185a        bridge              bridge              
4b0041303d6d        host                host                
7239bb9e0255        my-net              bridge              
016cf6ec1791        none                null

docker run -itd --name=web1 --net my-net nginx:latest
docker run -itd --name=db1 --net my-net -e MYSQL_ROOT_PASSWORD=pass mysql:latest

docker exec -it web1 sh
# ping db1
PING db1 (172.18.0.4): 56 data bytes
64 bytes from 172.18.0.4: icmp_seq=0 ttl=64 time=0.161 ms
# ping redis1
PING redis1 (172.18.0.3): 56 data bytes
64 bytes from 172.18.0.3: icmp_seq=0 ttl=64 time=0.168 ms
```

## 5. DNS server.
### 5.1 Default bridge network
- Khi container được chạy với network default bridge thì container sẽ sao chép nội dung file `/etc/resolv.conf` của host vào trong container. Do đó, dns-server được cấu hình trên máy host như thế nào, thì trên container tương tự như vậy.
- Kiểm tra trên container:
```sh
root@292a65a743ac:/# mount | grep /etc
/dev/disk/by-uuid/d9ed83b8-98cb-428a-9ad0-e7bf8ae36117 on /etc/resolv.conf type ext4 (rw,relatime,errors=remount-ro,data=ordered)
/dev/disk/by-uuid/d9ed83b8-98cb-428a-9ad0-e7bf8ae36117 on /etc/hostname type ext4 (rw,relatime,errors=remount-ro,data=ordered)
/dev/disk/by-uuid/d9ed83b8-98cb-428a-9ad0-e7bf8ae36117 on /etc/hosts type ext4 (rw,relatime,errors=remount-ro,data=ordered)
```

=> Ta thấy các file trên container được mount từ các file trên máy host.

- Kiểm tra nội dung file `resolv.conf`
```sh
root@292a65a743ac:/# cat /etc/resolv.conf 
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)
#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN
nameserver 8.8.8.8
nameserver 8.8.4.4
```

=> Tương tự trên máy host.

### 5.2 User-defined networks
- Docker sẽ sử dụng `built-in dns` riêng cho các container cùng 1 network.
- Nội dung file `/etc/resolv.conf`
```sh
root@07c8c10a7a81:/# cat /etc/resolv.conf 
nameserver 127.0.0.11
options ndots:0
root@07c8c10a7a81:/# 
```

- Docker chưa cung cấp công cụ để xem thông tin các record của built-in dns này.

### 5.3 Chỉ định sử dụng dns-server riêng
- Dùng cờ `--dns`: để khai báo dns-server sẽ sử dụng trong container:

```sh
root@docker2:/opt# docker run -it --name hcm --dns=10.10.10.1 ubuntu /bin/bash
```

## 6. MacVlan.
Macvlan cho phép cấu hình sub-interfaces (hay còn gọi là slave devices) trên một Ethernet interface vật lý (còn gọi là upper device), mỗi sub-interfaces này có địa chỉ MAC riêng và do đó có địa chỉ IP riêng. Các ứng dụng, VM và các containers có thể kết nối với một sub-interface nhất định để kết nối trực tiếp với mạng vật lý, sử dụng địa chỉ MAC và địa chỉ IP riêng của chúng.

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/hinhanh/macvlan.png)

#### LAB macvlan chế độ bridge
Trong khi macvlan có 4 chế độ (VEPA, bridge, private, passthrough), thì Docker macvlan driver chỉ hỗ trợ macvlan bridge mode.
- Mô hình:

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/hinhanh/lab_macvlan.png)

- Kiểm tra card mạng máy host
```sh
root@docker4:~# ifconfig -a
docker0   Link encap:Ethernet  HWaddr 02:42:b5:a4:86:55  
          inet addr:172.17.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

eth0      Link encap:Ethernet  HWaddr 52:54:00:f6:70:7a  
          inet addr:172.16.69.234  Bcast:172.16.69.255  Mask:255.255.255.0
          inet6 addr: fe80::5054:ff:fef6:707a/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:754142 errors:0 dropped:4 overruns:0 frame:0
          TX packets:225721 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:87515346 (87.5 MB)  TX bytes:34434449 (34.4 MB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:6 errors:0 dropped:0 overruns:0 frame:0
          TX packets:6 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:576 (576.0 B)  TX bytes:576 (576.0 B)
```

- Tạo card mạng macvlan chế độ bridge
```sh
root@docker4:~# docker network create -d macvlan --subnet 172.16.69.0/24 --gateway 172.16.69.1 --ip-range=172.16.69.240/28 -o parent=eth0 macvlan0                                             
```
Trong đó:
  - subnet và gateway: chỉ ra dải địa chỉ mạng thật.
  - ip-range: Chỉ ra dải địa chỉ sẽ được cấp cho container.

- Kiểm tra card mạng vừa tạo
```sh
root@docker4:~# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
89aacb502e1e        bridge              bridge              local
d1b81f6ed217        docker_gwbridge     bridge              local
e1ea5196a974        host                host                local
re92zy5a0lvn        ingress             overlay             swarm
bf347a55a5a4        macvlan0            macvlan             local
120c2a080b4f        none                null                local
```

- Tạo container1 và gắn vào card mạng vừa tạo
```sh
root@docker4:~# docker run -it --net macvlan0 --name alpine1 alpine /bin/sh
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
24: eth0@if2: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UNKNOWN 
    link/ether 02:42:ac:10:45:f0 brd ff:ff:ff:ff:ff:ff
    inet 172.16.69.240/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe10:45f0/64 scope link tentative 
       valid_lft forever preferred_lft forever
/ # 
```

- Kiểm tra ping gateway và ping ra ngoài internet
```sh
/ # ping 172.16.69.1
PING 172.16.69.1 (172.16.69.1): 56 data bytes
64 bytes from 172.16.69.1: seq=0 ttl=64 time=0.856 ms
64 bytes from 172.16.69.1: seq=1 ttl=64 time=0.580 ms
^C
--- 172.16.69.1 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.580/0.718/0.856 ms
/ # ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=45 time=40.851 ms
^C
--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 40.851/40.851/40.851 ms
/ # 
/ # exit
root@docker4:~# 
```

- Tạo container2 và gắn vào card mạng vừa tạo
```sh
root@docker4:~# docker run -it --net macvlan0 --name alpine2 alpine /bin/sh
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
25: eth0@if2: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UNKNOWN 
    link/ether 02:42:ac:10:45:f1 brd ff:ff:ff:ff:ff:ff
    inet 172.16.69.241/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe10:45f1/64 scope link 
       valid_lft forever preferred_lft forever
/ # 
```

- Ping container1, google
```sh
/ # ping 172.16.69.240
PING 172.16.69.240 (172.16.69.240): 56 data bytes
64 bytes from 172.16.69.240: seq=0 ttl=64 time=0.349 ms
64 bytes from 172.16.69.240: seq=1 ttl=64 time=0.139 ms
64 bytes from 172.16.69.240: seq=2 ttl=64 time=0.090 ms
64 bytes from 172.16.69.240: seq=3 ttl=64 time=0.282 ms
^C
--- 172.16.69.240 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.090/0.215/0.349 ms
/ # ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=45 time=32.703 ms
64 bytes from 8.8.8.8: seq=1 ttl=45 time=32.804 ms
64 bytes from 8.8.8.8: seq=2 ttl=45 time=32.803 ms
64 bytes from 8.8.8.8: seq=3 ttl=45 time=32.768 ms
^C
--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 32.703/32.769/32.804 ms
```

#### LAB macvlan chế độ bridge tính năng vlan
- Tính năng vlan sẽ phân chia các containers nằm trên từng vlan khác nhau. Giúp chúng ta dễ dàng quản lý các container.
- Định dạng của vlan sub-interface là `interface_name.vlan_tag`. Ví dụ: **eth0.50**

- Mô hình:

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/hinhanh/macvlan-vlan.png)

- Tạo network với `vlan tag` là `50` dựa trên interface `eth0`
```sh
docker network  create  -d macvlan \
    --subnet=192.168.50.0/24 \
    --gateway=192.168.50.1 \
    -o parent=eth0.50 macvlan50
```
- Tạo 2 containers dùng card mạng này: 
```sh
docker run --net=macvlan50 -it --name macvlan_test5 --rm alpine /bin/sh
docker run --net=macvlan50 -it --name macvlan_test6 --rm alpine /bin/sh
```

- Tạo network với `vlan tag` là `60` dựa trên interface `eth0`
```sh
docker network  create  -d macvlan \
    --subnet=192.168.60.0/24 \
    --gateway=192.168.60.1 \
    -o parent=eth0.60 -o \
    --macvlan_mode=bridge macvlan60
```
- Tạo 2 containers:
```sh
docker run --net=macvlan60 -it --name macvlan_test7 --rm alpine /bin/sh
docker run --net=macvlan60 -it --name macvlan_test8 --rm alpine /bin/sh
```

##### Kiểm tra
- Sau khi tạo 2 macvlan, ta thấy xuất hiện 2 sub-interface tương ứng là: `eth0.50@eth0` và `eth0.60@eth0`
```sh
root@docker4:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:f6:70:7a brd ff:ff:ff:ff:ff:ff
    inet 172.16.69.234/24 brd 172.16.69.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fef6:707a/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:b5:a4:86:55 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 scope global docker0
       valid_lft forever preferred_lft forever
33: eth0.50@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 52:54:00:f6:70:7a brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5054:ff:fef6:707a/64 scope link 
       valid_lft forever preferred_lft forever
36: eth0.60@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 52:54:00:f6:70:7a brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5054:ff:fef6:707a/64 scope link 
       valid_lft forever preferred_lft forever
```

- Trên containers `macvlan_test5` ping đến containers `macvlan_test6`:
```sh
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
34: eth0@if33: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UNKNOWN 
    link/ether 02:42:c0:a8:32:02 brd ff:ff:ff:ff:ff:ff
    inet 192.168.50.2/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:c0ff:fea8:3202/64 scope link 
       valid_lft forever preferred_lft forever
/ # ping 192.168.50.3
PING 192.168.50.3 (192.168.50.3): 56 data bytes
64 bytes from 192.168.50.3: seq=0 ttl=64 time=0.357 ms
64 bytes from 192.168.50.3: seq=1 ttl=64 time=0.107 ms
^C
--- 192.168.50.3 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.107/0.232/0.357 ms
/ # 
```

- Trên containers `macvlan_test5` ping đến containers `macvlan_test7`:
```sh
/ # ping 192.168.60.2
PING 192.168.60.2 (192.168.60.2): 56 data bytes
^C
--- 192.168.60.2 ping statistics ---
21 packets transmitted, 0 packets received, 100% packet loss
/ # 
```

#### Tạo multi-subnet trên cùng 1 sub-interface:
```sh
### Create multiple bridge subnets with a gateway of x.x.x.1:
docker network  create  -d macvlan \
  --subnet=192.168.164.0/24 --subnet=192.168.166.0/24 \
  --gateway=192.168.164.1  --gateway=192.168.166.1 \
   -o parent=eth0.166 \
   -o macvlan_mode=bridge macvlan64
```

```sh
docker run --net=macvlan64 --name=macnet54_test --ip=192.168.164.10 -itd alpine /bin/sh
docker run --net=macvlan64 --name=macnet55_test --ip=192.168.166.10 -itd alpine /bin/sh
docker run --net=macvlan64 --ip=192.168.164.11 -it --rm alpine /bin/sh
docker run --net=macvlan64 --ip=192.168.166.11 -it --rm alpine /bin/sh
```

- Khi tạo containers phải chỉ định rõ là sử dụng subnet nào.
- **Mặc dù cùng 1 sub-interface nhưng các containers chỉ có thể nói chuyện với nhau nếu nó nằm cùng 1 subnet.**

## 7. Ipvlan

Ipvlan khá giống so với macvlan, tuy nhiên nó có điểm khác so với macvlan là không gán địa chỉ MAC riêng cho các sub-interfaces. Các sub-interfaces chia sẻ chung địa chỉ MAC với parent interfaces (card vật lý trên đó tạo các sub-interfaces), nhưng có địa chỉ IP riêng.

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/hinhanh/ipvlan.png)

- Ipvlan L2: Ipvlan L2 hay Layer 2 mode tương tự với chế độ macvlan bridge mode.

- Ipvlan L3: Ipvlan L2 được coi coi như bridge hay switch giữa các sub-interfaces và parent interface. Tương tự như vậy, Ipvlan L3 hay Layer 3 mode được coi như thiết bị lớp 3 (như router) giữa các sub-interfaces và parent interfaces.

- Thông tin về macvlan và ipvlan các bạn có thể tham khảo thêm tại đây:
https://github.com/hocchudong/networking-team/blob/master/ThaiPH/Linux%20Networking/ThaiPH_macvlan_vs_ipvlan.md

- **Lab ipvlan mode 2 khá tương tự với phần macvlan chế độ bridge nên tôi sẽ không đề cập tại đây**

- Để sử dụng được chế độ ipvlan, các bạn phải kích hoạt tính năng **Experimental** và nên update lên kernel mới nhất:
  - Tạo file `/etc/docker/daemon.json` với nội dung:
  ```sh
  { "experimental": true }
  ```

  - Khởi động lại docker: `service docker restart`
    - Kiểm tra: Nếu trả về true là ok.
  ```sh
  $ docker version -f '{{.Server.Experimental}}'
  true
  ```

#### Lab ipvlan L3: Multi-Subnet Ipvlan L3 Network
- Mô hình

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/hinhanh/ipvlan_l3.png)

- Kiểm tra card mạng máy host
```sh
root@docker4:~# ifconfig -a
docker0   Link encap:Ethernet  HWaddr 02:42:b5:a4:86:55  
          inet addr:172.17.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

eth0      Link encap:Ethernet  HWaddr 52:54:00:f6:70:7a  
          inet addr:172.16.69.234  Bcast:172.16.69.255  Mask:255.255.255.0
          inet6 addr: fe80::5054:ff:fef6:707a/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:754142 errors:0 dropped:4 overruns:0 frame:0
          TX packets:225721 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:87515346 (87.5 MB)  TX bytes:34434449 (34.4 MB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:6 errors:0 dropped:0 overruns:0 frame:0
          TX packets:6 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:576 (576.0 B)  TX bytes:576 (576.0 B)
```

- Tạo network
```sh
root@docker4:~# docker network create -d ipvlan --subnet=192.168.100.0/24 --gateway=192.168.100.1 --subnet=192.168.200.0/24 --gateway=192.168.200.1 -o parent=eth0 -o ipvlan_mode=l3 ipvlan
```

```sh
root@docker4:~# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
20504846ae2b        bridge              bridge              local
e1ea5196a974        host                host                local
0f6b33a6df54        ipvlan              ipvlan              local
120c2a080b4f        none                null                local
root@docker4:~# 
```

- tạo container1 với subnet 192.168.100.0/24
```sh
root@docker4:~# docker run -it --name ipvlan_c1 --net=ipvlan --ip=192.168.100.2 alpine /bin/sh
```

```sh
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
31: eth0@if2: <BROADCAST,MULTICAST,NOARP,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UNKNOWN 
    link/ether 52:54:00:f6:70:7a brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.2/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fef6:707a/64 scope link 
       valid_lft forever preferred_lft forever
/ # 
```

**=> cùng mac với máy host**

- tạo container2 với subnet 192.168.200.0/24
```sh
root@docker4:~# docker run -it --name ipvlan_c2 --net=ipvlan --ip=192.168.200.2 alpine /bin/sh
```

```sh
/ # ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
32: eth0@if2: <BROADCAST,MULTICAST,NOARP,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UNKNOWN 
    link/ether 52:54:00:f6:70:7a brd ff:ff:ff:ff:ff:ff
    inet 192.168.200.2/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fef6:707a/64 scope link 
       valid_lft forever preferred_lft forever
/ # 
```

**=> cùng mac với máy host**

- Trên container2 ping container1
```sh
/ # ping 192.168.100.2
PING 192.168.100.2 (192.168.100.2): 56 data bytes
64 bytes from 192.168.100.2: seq=0 ttl=64 time=0.399 ms
64 bytes from 192.168.100.2: seq=1 ttl=64 time=0.095 ms
64 bytes from 192.168.100.2: seq=2 ttl=64 time=0.091 ms
64 bytes from 192.168.100.2: seq=3 ttl=64 time=0.104 ms
64 bytes from 192.168.100.2: seq=4 ttl=64 time=0.100 ms
64 bytes from 192.168.100.2: seq=5 ttl=64 time=0.292 ms
^C
--- 192.168.100.2 ping statistics ---
6 packets transmitted, 6 packets received, 0% packet loss
round-trip min/avg/max = 0.091/0.180/0.399 ms
/ # 
```

# Reference
- https://gist.github.com/nerdalert/c0363c15d20986633fda
- https://github.com/hocchudong/networking-team/tree/master/ThaiPH/Linux%20Networking
- http://www.dasblinkenlichten.com/docker-networking-101-host-mode/
- https://viblo.asia/euclid/posts/XqakEmmbkWK
- https://docs.docker.com/engine/userguide/networking/#the-dockergwbridge-network
- https://kipalog.com/posts/Cach-lien-ket-cac-container-lai-voi-nhau-trong-docker
- https://docs.docker.com/engine/userguide/networking/get-started-macvlan/
- https://www.slideshare.net/bbsali0/docker-networking-with-new-ipvlan-and-macvlan-drivers
- https://hicu.be/docker-networking-macvlan-bridge-mode-configuration
- https://hicu.be/docker-container-network-types
- https://sreeninet.wordpress.com/2016/05/29/docker-macvlan-and-ipvlan-network-plugins/
- https://sreeninet.wordpress.com/2016/05/29/macvlan-and-ipvlan/