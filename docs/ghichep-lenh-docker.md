# Các ghi chép lệnh hay dùng với docker

## Các lệnh khởi đầu

| STT | Lệnh                   | Ý nghĩa                                | Ví dụ                |
|-----|------------------------|--------------|------------------------------------------------|
| 1 | docker pull `ten_image` | Tải image có tên là http từ docker hub | `docker  pull httpd` |
| 2	| docker run  -d `ten_image`| Tạo container chạy ngầm               | `docker -d  pull httpd` |
| 3 | docker run  -d -p 81:80 `ten_image` | Tạo container chạy ngầm, ánh xạ port 81 của host với port 80 của container, | `docker -d -p 81:80  pull httpd`|
| 4 | docker ps hoặc docker container ls | Liệt kê ra các container đã tạo, lệnh này không cần đối số truyền vào | `docker ps` hoặc `docker container ls` |
| 5 | docker exec -it `ID_cua_contaier` bash| thực hiện tương tác với container sau khi được tạo, lưu ý, cần sử dụng đụng ID của  container mong muốn. Để thoát chế độ tương tác hãy ấn tổ hợp phím **CTL + p** và **CTL + q** | `docker exec -it 3e6196a97a3f` bash |  