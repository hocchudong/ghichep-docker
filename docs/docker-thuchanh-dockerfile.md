# Thực hành dockerfile

Dockerfile giúp bạn rất nhiều trong quá trình làm việc với docker. Docker có cấu trúc thành các phần rõ ràng.

Đầu tiên cần chỉ định image gốc được sử dụng trong quá trình tạo image mới bằng dockerfile
```sh
FROM ubuntu:14.04
```

Bổ sung thông tin về người tạo ra dockerfile này
```sh
MAINTAINER tannt
```

Chạy các lệnh sẽ cài đặt bổ sung gói cho image, giả sử tôi muốn tạo image apache.
```sh
RUN apt-get update -y && apt-get dist-upgrade -y && apt-get install apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*
```

Chỉ định một số cấu hình biến môi trường để apache chạy trong container:
```sh
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
```

Cung cấp cổng mà dịch vụ apache trong container kết nối ra ngoài:
```sh
EXPOSE 80
```

Tạo một script tên `dockerfile.sh` có nội dung dưới:
```sh
#!/bin/bash
mkdir -p apache && cd apache

cat << EOF > dockerfile
FROM ubuntu:14.04

MAINTAINER Kimbro Staken version: 0.1

RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
EOF

docker build -t apache_test .
```

Trên host, thực hiện lệnh sau để tạo ra một image tên là `apache_test`
```sh
bash dockerfile.sh
```
