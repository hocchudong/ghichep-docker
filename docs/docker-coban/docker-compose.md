# Docker Compose
- Compose là công cụ giúp định nghĩa và khởi chạy multi-container Docker applications.
- Chỉ với một câu lệnh, ta có thể dễ dàng create và start toàn bộ các services phục vụ cho việc chạy ứng dụng.

- Việc sử dụng Docker Compose được tóm lược trong 3 bước cơ bản sau:
  - Khai báo app’s environment với Dockerfile.
  - Khai báo các services cần thiết để chạy app trong docker-compose.yml.
  - Run docker-compose up và Compose sẽ start và run app.

# 1. Cài đặt
- Install using pip
```sh
$ pip install docker-compose
```

Hoặc bạn có thể sử dụng cách khác: 

- Install as a container
```sh
$ curl -L https://github.com/docker/compose/releases/download/1.11.2/run.sh > /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
```

# 2. Ví dụ chạy wordpress.
Chúng ta sẽ tạo ra 2 containers, 1 containers chứa mã nguồn wordpress và 1 containers chưa cơ sở dữ liệu mysql. Bằng cách định nghĩa trong file compose. Chỉ với 1 dòng lệnh khởi tạo, docker sẽ lập tức tạo ra 2 containers và sẵn sàng cho chúng ta dựng lên wordpress, một cách nhanh chóng.

- Đoạn mã compose: Viết theo cú pháp **YAML**.
```sh
version: '2'

services:
   db:
     image: mysql:5.7
     volumes:
       - ./data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: wordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8000:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_PASSWORD: wordpress
```

- `version: '2'`: Chỉ ra phiên bản docker-compose sẽ sử dụng.
- `services:`: Trong mục services, chỉ ra những services (containers) mà ta sẽ cài đặt. Ở đây, tạo sẽ tạo ra services tương ứng với 2 containers là db và wordpress.
- Trong services db: 
  - image: chỉ ra image sẽ được sử dụng để create containers. Ngoài ra, bạn có thể viết dockerfile và khai báo lệnh `build` để containers sẽ được create từ dockerfile.
  - volumes: mount thư mục data trên host (cùng thư mục cha chứa file docker-compose) với thư mục /var/lib/mysql trong container.
  - restart: always: Tự động khởi chạy khi container bị shutdown.
  - environment: Khai báo các biến môi trường cho container. Cụ thể là thông tin cơ sở dữ liệu.
- Trong services wordpress:
  - depends_on: db: Chỉ ra sự phụ thuộc của services wordpress với services db. Tức là services db phải chạy và tạo ra trước, thì services wordpress mới chạy.
  - ports: Forwards the exposed port 80 của container sang port 8000 trên host machine.
  - environment: Khai báo các biến môi trường. Sau khi tạo ra db ở container trên, thì sẽ lấy thông tin đấy để cung cấp cho container wordpress (chứa source code).

- Khởi chạy
```sh
root@adk:/opt/test/data# docker-compose up
```
- Kết quả
```sh
root@adk:/opt/test/data# docker-compose ps
      Name                    Command               State          Ports         
--------------------------------------------------------------------------------
test_db_1          docker-entrypoint.sh mysqld      Up      3306/tcp             
test_wordpress_1   docker-entrypoint.sh apach ...   Up      0.0.0.0:8080->80/tcp 
root@adk:/opt/test/data# 
```

```sh
root@adk:/opt/test/data# docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
54cfd8a41b73        wordpress:latest    "docker-entrypoint..."   7 minutes ago       Up 7 minutes        0.0.0.0:8080->80/tcp     test_wordpress_1
68460ffee3c4        mysql:5.7           "docker-entrypoint..."   7 minutes ago       Up 7 minutes        3306/tcp                 test_db_1
```

# 3. Một vài chú ý:
- dockerfile dùng để build các image.
- docker-compose dùng để build và run các container.
- docker-compose viết theo cú pháp **YAML**, các lệnh khai báo trong docker-compose gần tương tự với thao tác chạy container `docker run`.
- docker-compose cung chấp chức năng `Horizontally scaled`, cho phép ta tạo ra nhiều container giống nhau một cách nhanh chóng. Bằng cách sử dụng lệnh
```sh
docker-compose scale name_service=5
```

Trong đó, **name_service** là tên services cần tạo container. **5** là số container sẽ được tạo ra.

# References
- https://viblo.asia/euclid/posts/DXOkRZYwkdZ
- https://docs.docker.com/compose/wordpress/#define-the-project