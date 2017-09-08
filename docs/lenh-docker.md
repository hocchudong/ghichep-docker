# Tập hợp các lệnh sử dụng trong Docker

#### Pull một image từ Docker Hub
```sh
docker pull {image_name}
```

#### Liệt kê các images hiện có
```sh
docker images
```

#### Xóa một image
```sh
docker rmi {image_id/name}
```

#### Liệt kê các container đang chạy
```sh
docker ps
docker ps -a #Liệt kê các container đã tắt
```

#### Xóa một container
```sh
docker rm -f {container_id/name}
```

#### Đổi tên một container
```sh
docker rename {old_container_name} {new_container_name}
```

#### Khởi động một container 
```sh
docker start {new_container_name}
docker exec -it {new_container_name} /bin/bash
```

#### Tạo mới một container, đồng thời khởi động với tùy chọn cổng và volume
```sh
docker run --name {container_name} -p {host_port}:{container_port} -v {/host_path}:{/container_path} -it {image_name} /bin/bash
```

#### Xem các thay đổi trên container
```sh
docker diff {container_name}
```

#### Commit các thay đổi trên container và image
```sh
docker commit -m "message" {container_name} {image_name}
```

#### Save image thành file .tar
```sh
docker save {image_name} > {/host_path/new_image.tar}
```

####Tạo một image mới từ file .tar
```sh
cat musashi.tar | docker import - {new_image_name}:latest
```

#### Xem lịch sử các commit trên image
```sh
docker history {image_name}
```

#### Khôi phục lại images từ IMAGE_ID
```sh
docker tag {iamge_id} {image_new_name}:{tag}
```

#### Build một image từ container
```sh
docker build -t {container_name} .
Dấu . ở đây ám chỉ Dockerfile đang nằm trong thư mục hiện tại.
```

#### Copy file từ host vào container
```sh
docker cp foo.txt mycontainer:/foo.txt
```

#### Copy file từ container vào host
```sh
docker cp mycontainer:/foo.txt foo.txt
```

## Reference
https://kipalog.com/posts/Cac-lenh-co-ban-voi-docker