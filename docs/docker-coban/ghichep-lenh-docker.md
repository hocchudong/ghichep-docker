# Các ghi chép lệnh hay dùng với docker

## Các lệnh làm việc với image

| STT | Lệnh | Ý nghĩa  | Ví dụ                           |
|--|--|--|------------------------------------------------|
| 1 | docker pull `ten_image` | Tải image có tên là http từ docker hub | `docker  pull httpd` |
| 2	| docker search  -d `ten_image`| Tìm kiếm các images | `docker search wordpress` |
| 3 | docker images| Liệt kê các images đã tải về, lệnh này không có đối số truyền vào | docker images | 
| 4 | docker rmi  -f `ten_image`| Xóa image đã tải với tùy chọn `-f` | docker rmi  -f httpd | 


## Các lệnh làm việc chính với container image

| STT | Lệnh | Ý nghĩa  | Ví dụ                           |
|--|--|--|------------------------------------------------|
| 1	| docker run  -d `ten_image`| Tạo container chạy ngầm | `docker -d  pull httpd` |
| 2 | docker run  -d -p 81:80 `ten_image` | Tạo container chạy ngầm, ánh xạ port 81 của host với port 80 của container, | `docker -d -p 81:80  pull httpd`|
| 3 | docker ps hoặc docker container ls | Liệt kê ra các container đã tạo, lệnh này không cần đối số truyền vào | `docker ps` hoặc `docker container ls` |
| 4 | docker exec -it `ID_cua_contaier` bash| thực hiện tương tác với container sau khi được tạo, lưu ý, cần sử dụng đụng ID của  container mong muốn. Để thoát chế độ tương tác hãy ấn tổ hợp phím **CTL + p** và **CTL + q** | `docker exec -it 3e6196a97a3f` bash |  
|5| docker stop `ID_cua_contaier` | Tạm dựng hoạt động của container | `docker stop 3e6196a97a3f`|
|6| docker rm `ID_cua_contaier` | Xóa  container | `docker rm 3e6196a97a3f`|
|6| docker stop $(docker ps -a -q) &&  docker rm $(docker ps -a -q) | Xóa tất cả các container, lệnh này không có đối số truyền vào. Lưu ý cần gõ 2 lệnh | `docker stop $(docker ps -a -q)` && `docker rm $(docker ps -a -q)`|


## Các lệnh làm việc với volume 
