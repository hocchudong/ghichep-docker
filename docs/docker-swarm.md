# Docker swarm
Docker swarm là một công cụ giúp chúng ta tạo ra một clustering Docker. Nó giúp chúng ta gom nhiều Docker Engine lại với nhau và ta có thể "nhìn" nó như duy nhất một virtual Docker Engine. 

- Trong phiên bản v1.12.0, Docker Swarm là một tính năng được tích hợp sẵn trong Docker Engine.

Trong phần này, tôi sẽ tạo ra 1 cụm cluster gồm 1 manager và 2 worker chạy dịch vụ web-server.
- node manager sẽ là node quản lý cluster.
- node worker là các node chạy dịch vụ. Nếu mà node worker die thì node manager sẽ run container trên chính nó.

# 1. Mô hình.

- manager: 172.16.69.228
- worker1: 172.16.69.218
- worker2: 172.16.69.214

# 2. Cài đặt.
- Lưu ý, tất cả được thực hiện dưới quyền root.

## 2.1 Cài đặt docker engine trên tất cả các node.
```sh
curl -sSL https://get.docker.io | bash
```

## 2.2 Trên node manager, tạo cluster

```sh
docker@manager:~$ docker swarm init --advertise-addr 172.16.69.228

Swarm initialized: current node (a35hhzdzf4g95w0op85tqlow1) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-0kc72gpnhhqnykw56ujwusdtfu5v0thpnmicynktvi8y6lhluc-1kvl428ru2oxx3zgn566gtkmw \
    172.16.69.228:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

- Nếu bạn muốn add thêm các node manager khác, chạy lệnh sau trên node manager:
```sh
docker@manager:~$ docker swarm join-token manager
To add a manager to this swarm, run the following command:
docker swarm join \
 — token SWMTKN-1–5mgyf6ehuc5pfbmar00njd3oxv8nmjhteejaald3yzbef7osl1–8xo0cmd6bryjrsh6w7op4enos \
 172.16.69.228:2377
```

=> Sau khi chạy lệnh, ta chỉ cần copy dòng lệnh ở output trên vào chạy ở node manager muốn thêm.

## 2.3 Join worker vào cluster vừa tạo.
- Trên worker1: 
```sh
root@worker1:~# docker swarm join \
>     --token SWMTKN-1-0kc72gpnhhqnykw56ujwusdtfu5v0thpnmicynktvi8y6lhluc-1kvl428ru2oxx3zgn566gtkmw \
>     172.16.69.228:2377
This node joined a swarm as a worker.
```

- Tương tự, trên worker2
```sh
root@worker2:~# docker swarm join \
>     --token SWMTKN-1-0kc72gpnhhqnykw56ujwusdtfu5v0thpnmicynktvi8y6lhluc-1kvl428ru2oxx3zgn566gtkmw \
>     172.16.69.228:2377
This node joined a swarm as a worker.
```

- Các bạn chú ý, giá trị token là giá trị lúc tạo manager node.

- Nếu các bạn quên giá trị token, chạy lệnh sau trên node manager để lấy token.
```sh
root@manager:/opt/swarm# docker swarm join-token worker
To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-0kc72gpnhhqnykw56ujwusdtfu5v0thpnmicynktvi8y6lhluc-1kvl428ru2oxx3zgn566gtkmw \
    172.16.69.228:2377
```

# 3. Kết quả.
- Kiểm tra các node:
```sh
docker@manager:~$ docker node ls

ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
kuiombcp396m6tkyln30yr8vp *  adk       Ready   Active        Leader
mss8z9cbfbp15s6hapaoyfail    adk       Ready   Active        
vh7ezyxntkuys6lwnwz4rwc0g    adk       Ready   Active        
```

# 4. Run service
- Trong phần này, tôi sẽ kết hợp docker-compose cùng docker swarm để deploy web-server như ban đầu đã nói.

## 4.1 Docker-Compose

```sh
version: '3'
services:
   web:
     image: cosy294/swarm:1.0
     ports:
       - "9000:80"
     deploy:
       mode: replicated
       replicas: 3
```

- Các bạn chú ý phần deploy:
  - **mode: replicated**: kết hợp với **replicas: 3** Nó có nghĩa là tạo ra 3 container.
  - Nếu **mode** là **global** thì mỗi node sẽ chỉ tạo ra 1 container.

- Enable Experimental: Tạo file `/etc/docker/daemon.json`
```sh
{
    "experimental": true
}
```

- Khởi động lại docker
```sh
service docker restart
```

- Kiểm tra tính năng experimental đã bật hay chưa
```sh
$ docker version -f '{{.Server.Experimental}}'
true
```

- Lệnh deploy
```sh
docker deploy --compose-file docker-compose.yml linhlt
```

- Kết quả:
```sh
root@manager:/opt/swarm# docker service ls
ID            NAME        MODE        REPLICAS  IMAGE
piny444k1b8q  linhlt_web  replicated  3/3       cosy294/swarm:1.0
```

```sh
root@manager:/opt/swarm# docker service ps linhlt_web
ID            NAME              IMAGE              NODE  DESIRED STATE  CURRENT STATE              ERROR  PORTS
nx2id4wolgbj  linhlt_web.1      cosy294/swarm:1.0  adk   Running        Running about an hour ago         
tkhoybpc86j2  linhlt_web.2      cosy294/swarm:1.0  adk   Running        Running 25 minutes ago            
xyrn0rkkj2t4  linhlt_web.3      cosy294/swarm:1.0  adk   Running        Running about an hour ago         
```

## 4.2 Tính năng scale.
Docker hỗ trợ tính năng scale, có thể thay đổi số container của cluster một cách nhanh chóng bằng câu lệnh sau:
```sh
docker service scale name_service=5
```

- Trong đó, name_service là tên của service.
- Tùy theo số container hiện tại của service mà docker có thể tăng hoặc giảm cho đúng với số lượng khai báo ở lệnh trên.

## 5.Thử nghiệm
### 5.1 Thử nghiệm 1: Cách các container xử lý request.
Trong image `cosy294/swarm:1.0`, tôi có cung cấp 1 file `hostname.php` với ý nghĩa là xuất ra hostname của container đang chạy service.
- Tôi viết một đoạn scripts như sau:
```sh
#!/bin/bash
for (( i = 1; $i <=12; i++ )); do
  echo $i >> kq.txt
  curl http://172.16.69.228:9000/hostname.php >> kq.txt
  echo -e "\n" >> kq.txt
  sleep 15
done
```

=> Đoạn scripts này có ý nghĩa là sẽ lấy giá trị hostname trong 12 request.

- Tôi nhận được kết quả:
```sh
root@adk:/opt/swarm# cat kq.txt 
1
642a2a4ae3b8

2
826de3323cb3

3
e36ce7cf9383

4
642a2a4ae3b8

5
e36ce7cf9383

6
826de3323cb3

7
642a2a4ae3b8

8
e36ce7cf9383

9
642a2a4ae3b8

10
e36ce7cf9383

11
826de3323cb3

12
642a2a4ae3b8
```

- Các giá trị trên là giá trị của các hostname của container xử lý request.
- **Rút ra được kết luận:** Các container sẽ **luân phiên** tiếp nhận và xử lý các request đến từ người dùng.

### 5.2 Thử nghiệm 2: Stop docker container.
- Khi tôi shutdown một container trong node worker1, thì ngay lập tức 1 container mới được tạo ra để đảm bảo 
số container là 3.

- Khi tôi stop services docker ở worker1, thì ngay lập tức các container mới sẽ được ta ở các node khác để đảm bảo số container là 3.

# Reference
- https://docs.docker.com/engine/swarm/swarm-tutorial/
- http://trumhemcut.net/2016/06/26/gioi-thieu-cac-tinh-nang-moi-trong-docker1-12/