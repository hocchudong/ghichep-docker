# Thực hành với docker volume
- Có 2 kiểu volume trong docker
  - bind mount: gắn trực tiếp một thư mục hoặc file của host với container
  - docker mananged volume: 
  
Thực hiện tạo một container sử dụng volume kiểu `bind mount` như sau:
```sh
mkdir -p /root/web_test && cd /root/web_test

docker run --name apache_test2 -p 8080:80 -p 443:443 -v /root/web_test:/var/www/ -d eboraas/apache
```

Kiểm tra volume đang được mount vào trong container bằng lệnh
```sh
docker inspect -f '{{ .Mounts }}'  apache_test2
```

==> Kết quả kiểm tra:
```sh
[{bind  /root/web_test /var/www   true rprivate}]
```

Nếu kiểm tra bằng lệnh `docker inspect apache_test2`:
```sh
"Mounts": [
    {
        "Type": "bind",
        "Source": "/root/web_test",
        "Destination": "/var/www",
        "Mode": "",
        "RW": true,
        "Propagation": "rprivate"
    }
],
```

Thực hiện thêm file trong thư mục được mount vào container để xem container có không:
```sh
touch local_file

docker exec apache_test2 ls /var/www/
```

Mặc định `container` sẽ có quyền `rw` trên volume được gắn thêm vào. chỉ định để container chỉ có quyền đọc bằng cách thêm tham số `ro` sau chỉ dẫn mount volume:
```sh
docker run --name apache_test3 -p 8081:80 -p 444:443 -v /root/web_test:/var/www/:ro -d eboraas/apache
```

**Note**: Volume được gắn vào theo kiểu `bind mount` sẽ tạo mới đường dẫn được gắn hoặc nếu có đường dẫn rồi thì ghi đè toàn bộ dữ liệu.

---------------

Sử dụng kiểu `docker mananged volume`. Ta tạo volume bằng lệnh:
```sh
docker volume create --name avolume
```

Kiểm tra volume vừa tạo:
```sh
docker volume inspect avolume
```

Ta tạo một container với kiểu `docker mananged volume`:
```sh
mkdir -p /root/web_test2 && cd /root/web_test2

docker run --name apache_test3 -p 8081:80 -p 444:443 -v avolume:/var/www/ -d eboraas/apache
```

Kiểm tra volume gắn vào container `apache_test3`:
```sh
docker inspect -f '{{ .Mounts }}'  apache_test3
```

==> Kết quả:
```sh
[{volume avolume /var/lib/docker/volumes/avolume/_data /var/www local z true }]
```

Nếu kiểm tra bằng lệnh `docker inspect apache_test3`:
```sh
"Mounts": [
    {
        "Type": "volume",
        "Name": "avolume",
        "Source": "/var/lib/docker/volumes/avolume/_data",
        "Destination": "/var/www",
        "Driver": "local",
        "Mode": "z",
        "RW": true,
        "Propagation": ""
    }
],
```

Ngữ cảnh sử dụng `bind mount` trong trường hợp cần đồng bộ thư mục từ host vào container, sẽ tạo mới đường dẫn hoặc ghi đè thư mục trong container.

Ngữ cảnh sử dụng `docker mananged volume` trong trường hợp muốn đồng bộ thư mục giữa host và container mà ko xóa dữ liệu cũ trong container đang có.

**Note**: dữ liệu trên volume sẽ không được lưu vào image khi sử dụng lệnh `docker commit <container> <image>`