# Thực hành container

Liệt kê số lượng container đang chạy (run) trên host
```sh
docker ps
```

Thêm tham số `-a` để liệt kê tất cả các container đang có trên host (bao gồm cả đang chạy và dừng)
```sh
docker ps -a
```

Tạo một container từ image, nếu image không có sẵn trên local host thì docker sẽ tìm trên `docker hub` image phiên bản `latest` để tải về và chạy.
```sh
docker run [image_name]
```

Ví dụ:

![docker_run](../images/docker_run.png)

Đặt tên cho một container khi khởi tạo, thêm tham số `--name`
```sh
docker run --name ubuntu_test ubuntu
```

Tạo một docker và sử dụng terminal của docker
```sh
docker run -it ubuntu /bin/bash
```

**Note**: Chỉ sử dụng tham số `-it` thì khi thoát terminal của docker bằng `exit`, docker sẽ bị dừng.

Chỉ định chạy một docker dưới nền như một deamon. 
```sh
docker run -d ubuntu /bin/bash
```

Vào terminal của một container đang chạy
```sh
docker exec -it [container_ID/container_name] /bin/bash
```

Thoát ra khỏi một container khi đang sử dụng terminal bằng cách:
- Gõ `exit`
- Nhấn tổ hợp phím `Ctl+P` và `Ctl+Q`

Xóa một container ở trạng thái `Exited`
```sh
docker rm [container_ID/container_name]
```

Xóa một container ở trạng thái `Up` thì thêm tham số `-f`
```sh
docker rm -f [container_ID/container_name]
```

Commit một container thành image
```sh
docker commit [container_ID/container_name] [image_name]:latest
```