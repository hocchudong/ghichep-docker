# Thực hành image

Tìm kiếm một image từ docker hub, ví dụ tìm kiếm image về apache
```sh
docker search apache
```

Tải một image về máy
```sh
docker pull httpd
```

Liệt kê tất cả các image đang có trên local
```sh
docker images
```

Xem chi tiết thông tin về image
```sh
docker image inspect httpd
```

Xem lịch sử các commit của image
```sh
docker history [image_ID/image_name]
```

Xóa một image
```sh
docker rmi [image_ID/image_name]
```

Đổi lại `tag` của một image
```sh
docker tag [image_name] [image_new_name]:[tag]
```

Cách tra cứu cú pháp các command về image
```sh
docker [command] --help
```

Ví dụ
```sh
docker image --help

docker image pull --help
```