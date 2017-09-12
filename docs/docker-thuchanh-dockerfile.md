# Thực hành dockerfile

Dockerfile giúp bạn rất nhiều trong quá trình làm việc với docker. Dockerfile có cấu trúc thành các phần rõ ràng.

Dưới đây là một kiến trúc các thành phần cơ bản trong một `dockerfile`:

- Đầu tiên cần chỉ định image gốc được sử dụng trong quá trình tạo image mới bằng dockerfile
```sh
FROM ubuntu:14.04
```

- Bổ sung thông tin về người tạo ra dockerfile này
```sh
MAINTAINER tannt
```

- Chạy các lệnh sẽ cài đặt bổ sung gói cho image, giả sử tôi muốn tạo image apache.
```sh
RUN apt-get update -y && apt-get install apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*
```

- Chỉ định một số cấu hình biến môi trường để apache chạy trong container:
```sh
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www
```

- Cung cấp cổng mà dịch vụ apache trong container kết nối ra ngoài:
```sh
EXPOSE 80
```

- Lệnh mà ứng dụng trong container được tạo ra sẽ thực thi:
```sh
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
```

Bây giờ ta sẽ tổng hợp các thành phần rời rạc ở trên thành một tập tin hoàn chỉnh và tạo image:

- Tạo một script tên `dockerfile.sh` có nội dung dưới:
```sh
#!/bin/bash
mkdir -p apache && cd apache

cat << EOF > dockerfile
FROM ubuntu:14.04

MAINTAINER tannt

RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
EOF

docker build -t apache_test .
```

- Trên host, thực hiện lệnh sau để tạo ra một image tên là `apache_test`
```sh
bash dockerfile.sh
```

Kiểm tra image có tên `apache_test` vừa tạo
```sh
docker images
```

Tạo container từ image mới tạo bởi dockerfile
```sh
docker run -it apache_test /bin/bash
```