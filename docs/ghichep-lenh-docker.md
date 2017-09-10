# Các ghi chép lệnh hay dùng với docker

## Các lệnh khởi đầu

| STT | Lệnh                   | Ý nghĩa                                | Ví dụ                |
|-----|------------------------|----------------------------------------|----------------------|
| 1   | docker pull ten_image  | Tải image có tên là http từ docker hub | `docker  pull httpd` |
| 2	  | docker run  -d ten_image| Tạo container chạy ngầm               | `docker -d  pull httpd` |
| 3    | docker run  -d -p 81:80 ten_image | Tạo container chạy ngầm, ánh xạ port 81 của host với port 80 của container | `docker -d -p 81:80  pull httpd`|