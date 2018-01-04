# Thực hành image

Tìm kiếm một image từ docker hub, ví dụ tìm kiếm image về apache:
```sh
docker search apache
```

- Thay `apache` bằng tên image bạn muốn tìm

Tải một image về máy:
```sh
docker pull httpd
```
- thay `httpd` bằng tên image bạn muốn tải về local

Liệt kê tất cả các image đang có trên local:
```sh
docker images
```

Xem chi tiết thông tin về image:
```sh
docker image inspect httpd
```

Xem lịch sử các commit của image:
```sh
docker history httpd
```

- thay `httpd` bằng tên hoặc ID của image bạn muốn xem thông tin. 

Xóa một image:
```sh
docker rmi httpd
```

- thay `httpd` bằng tên hoặc ID image bạn muốn xóa
- Xóa tất cả các image bằng lệnh `docker rmi -f $(docker images -qa)`
- Khi `image` đang được sử dụng để `run` một `container` thì muốn xóa, bạn cần thêm tham số `-f`
        
Đổi lại `tag` của một image:
```sh
docker tag httpd httpd:1.0
```

- `httpd` là image đang có. `httpd:1.0` là tên mới của image có phiên bản `1.0`, nếu không điền thì được mặc định là `latest`
- có thể chỉ định thêm `repository` sẽ upload image, tôi sử dụng `repository` là `tannt`: `docker tag httpd tannt/httpd:1.0`

Cách tra cứu cú pháp các command về image:
```sh
docker [command] --help
```

Ví dụ:
```sh
docker image --help

docker image pull --help
```