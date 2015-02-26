### Volume trong Docker
Volume trong Docker được dùng để chia sẻ dữ liệu cho container.
- Để sử dụng volume trong docker dùng cờ hiệu (flag) -v trong lệnh `docker run`.


Có thể sử dụng Volume trong Docker trong những trường hợp sau
- Chia sẻ giữa container và container.
- Chia sẻ giữa container và host.

#### Sử dụng volume để chia sẻ dữ liệu giữa host và container
Trong tình huống này thư mục trên máy host (máy chứa container) sẽ được mount với một thư mục trên container, dữ liệu sinh ra trên thư mục được mount của container sẽ xuất hiện trên thư mục của host. 
- Ví dụ: 
```sh 
- Tạo ra thư mục bindthis trên host, có đường dẫn /root/bindthis. 
- Thư mục `/root/bindthis` này sẽ được mount với thư mục /var/www/html/webapp nằm trên container.
- Tạo ra 1 file trong thư mục /var/www/html/webapp trên container.
- Kiểm tra xem trong thư mục /root/bindthis trên host có hay không.
```