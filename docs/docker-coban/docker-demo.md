# Demo docker

- Đảm bảo đã cài docker thành công
- Môi trường demo: OS của host là `CentOS 7.3 64bit`, `Docker CE 17.07`

## Demo docker - wordpress
- Thực hiện lệnh dưới để cài đặt wordpress

- Bước 1: Tạo 1 container để chạy môi trường mysql
  ```sh
	docker run \
	-e MYSQL_ROOT_PASSWORD=root \
	-e MYSQL_USER=wpuser \
	-e MYSQL_PASSWORD=vnptdata2017 \
	-e MYSQL_DATABASE=wordpress_db \
	--name wordpressdb -d mariadb
	```

- Bước 2: Tạo một container chạy wordpress và liên kết với container có tên là `demo_mysql`
	```sh
	docker run \
	-e WORDPRESS_DB_USER=wpuser \
	-e WORDPRESS_DB_PASSWORD=vnptdata2017 \
	-e WORDPRESS_DB_NAME=wordpress_db \
	-p 8080:80 \
	--link wordpressdb:mysql \
	--name wpcontainer1 -d wordpress
	```

- Giải thích các tùy chọn
  - `--name demo_wordpress`: tên của container
  - `--link demo_mysql:mysql` : container demo-wordpress sẽ liên kết với container có tên là `demo-mysql` , container `demo-mysql` được tạo ra từ images có tên là `mysql`
  - `-p 8080:80`: mapping port 8080 của host
  - `-d` : container tạo ra sẽ được chạy ngầm
  - `wordpress`: Tên của images, tên là `wordpress`


- Bước 3: Mở trình duyệt web để truy cập vào wordpress với đường dẫn: `http://ip_cua_host:8080/`
  
## Demo docker - drupal

## Demo docker - zabbix
- Thực hiện các bước sau đây để tạo docker chạy zabbix

- Bước 1: Tạo một container chạy DB cho zabbix
	```sh
docker run \
	-d \
	--name zabbix-db \
	--env="MARIADB_USER=zabbix" \
	--env="MARIADB_PASS=my_password" \
	monitoringartist/zabbix-db-mariadb
	```

- Bước 2: Tạo một container chạy zabbix và liên kết với container có tên là `zabbix-db` vừa tạo ở bên trên
	```sh
	docker run \
		-d \
		--name zabbix \
		-p 81:80 \
		-p 10051:10051 \
		-v /etc/localtime:/etc/localtime:ro \
		--link zabbix-db:zabbix.db \
		--env="ZS_DBHost=zabbix.db" \
		--env="ZS_DBUser=zabbix" \
		--env="ZS_DBPassword=my_password" \
		--env="XXL_zapix=true" \
		--env="XXL_grapher=true" \
		monitoringartist/zabbix-xxl:latest
	```

- Bước 3: Truy cập vào web với địa chỉ `http://ip_cua_host:81/`. Tài đăng nhập bằng tài khoản `Admin` (Lưu ý ký tự A cần được viết hoa) và mật khẩu là `zabbix`. 


## Demo docker - rabbitmq
- Thực hiện lệnh dưới để cài đặt rabbitmq

### Lab1: Cài đặt rabbitmq stand alone 

- Bước 1: Thực hiện lệnh dưới để cài đặt rabbitmq có kèm theo trang quản trị.
	```sh
	docker run -d --hostname my-rabbit --name some-rabbit -p 8081:15672 rabbitmq:3-management
	```

- Giải thích tham số
  - `-d`: Tạo container chạy ngầm
  - `--hostname my-rabbit` : tên bên trong container
  - `--name some-rabbit` : Tên của container (có thể quan sát bằng lệnh `docker ps`)
  - `-p 8081:15672` : mapping port 8081 của host với port 15672 của container. Port 15672 là port trang quản trị mặc định của rabbitmq
  
Bước 2: đăng nhập vào trang quản trị của rabbitmq bằng địa chỉ `http://ip_cua_host:8081/`. Tài khoản là `guest`, mật khẩu là `guest`

  
