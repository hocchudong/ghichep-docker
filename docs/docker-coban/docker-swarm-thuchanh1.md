## Thực hành với docker swarm 



### Yêu cầu
- Cần có môi trường cài đặt theo tài liệu [Cài đặt docker swarm](./docker-thuchanh-caidat-dockerswarm.md)
- Đảm bảo theo mô hình và kiểm tra hoạt động của docker swarm cơ bản thành công trước khi tiến hành các bài thực hành bên dưới.

#### Sử dụng docker swarm để triển khai wordpress

- Tham khảo: http://www.cnblogs.com/CloudMan6/p/8098761.html

Chúng ta sẽ sử dụng docker swarm để triển khai wordpress trong các container. Kết quả sau khi triển khai ta sẽ có ứng dụng wordpress được triển khai trên docker swarm. Trong hướng dẫn này ta sẽ sử dụng 02 service để phục vụ triển khai wordpress, đó là
  - service có tên là `mysql`: Chạy database.
  - service có tên là `wordpress`: Chạy mã nguồn của wordpress.

Cần lưu ý rằng khi mỗi service được tạo ở trên có thể có 1 hoặc nhiều container, việc này vụ thuộc vào nhu cầu mà bạn triển khai sau này. Trong hướng dẫn này chúng tôi sẽ sử dụng mỗi service là một container. 
  
##### Tạo mật khẩu cho các container bằng kỹ thuật `secret` trong docker.

- Sử dụng lệnh dưới để sinh ra chuỗi ngẫu nhiên để làm mật khẩu của tài khoản `root` cho container chạy mysql ở tương lai.

  ```sh
  openssl rand -base64 20 | docker secret create mysql_root_password -
  ```

  - Kết quả trả về là một chuỗi sinh ra ngẫu nhiên
    ```sh
    root@srv1:~# openssl rand -base64 20 | docker secret create mysql_root_password -
    y90v0zf2k8i9yooyp6vfug03p
    ```


- Trong thực tế khi triển khai wordpress hoặc các ứng dụng tương tự thì chúng ta không sử dụng tài khoản root của mysql để cấu hình, do vậy ta sẽ tạo thêm mật khẩu cho mysql để wordpress kết nối tới. Còn mật khẩu của tài khoản `root` ở trên là để sử dụng cho việc quản trị database trong container chạy mysql sau này. Ta làm tương tự như trên đối với việc sinh ra `secret` cho ứng dụng wordpress.

  ```sh
  openssl rand -base64 20 | docker secret create mysql_password -
  ```
  
  - Kết quả như bên dưới: 
    ```sh
    root@srv1:~# openssl rand -base64 20 | docker secret create mysql_password -
    v7uz3bwjvy497q9b869qm649h
    ```

- Cần lưu ý rằng ta sẽ phải ghi lại 02 chuỗi ở bên trên để sử dụng sau này. Ngoài ra, ta có thể kiểm tra các `secret` đã tạo ở trên bằng lệnh sau:

  ```sh
  docker secret list
  ````
  
  - Kết quả trả về là:
    ```sh
    ID                          NAME                  DRIVER              CREATED              UPDATED
    v7uz3bwjvy497q9b869qm649h   mysql_password                            About a minute ago   About a minute ago
    y90v0zf2k8i9yooyp6vfug03p   mysql_root_password                       8 minutes ago        8 minutes ago
    ````

##### Tạo overlay network

- Mục tiêu tạo ra `overlay network` là để cho các container có thể nói chuyện với nhau thông qua tên của các container (Tên đã được liệt kê ở trên). Lệnh dưới sẽ tạo một overlay network có tên là `mysql_private`.
  ```sh
  docker network create -d overlay mysql_private
  ```

- Sau khi tạo xong network overlay, ta kiểm tra lại bằng lệnh `docker network ls`, kết quả ta sẽ nhìn thấy tên của network vừa tạo ở trên là thành công.

##### Tạo các container để chạy wordpress.

- Tạo container chạy mysql.

  ```sh
  docker service create \
       --name mysql \
       --network mysql_private \
       --secret source=mysql_root_password,target=mysql_root_password \
       --secret source=mysql_password,target=mysql_password \
       -e MYSQL_ROOT_PASSWORD_FILE="/run/secrets/mysql_root_password" \
       -e MYSQL_PASSWORD_FILE="/run/secrets/mysql_password" \
       -e MYSQL_USER="wordpress" \
       -e MYSQL_DATABASE="wordpress" \
       mysql:latest
  ```

Ở trên ta lưu ý:
  - `--name` là tùy chọn chỉ định tên của container, trong trường hợp này là `mysql`
  - `--network` là tên của network overlay vừa tạo ở bên trên, cần nhập đúng tên đã đặt ở bên trên.
  - `--secret` là tùy chọn khai báo cho mật khẩu của database đã tạo ở bước trên.
  - `-e MYSQL_ROOT_PASSWORD_FILE` và `-e MYSQL_PASSWORD_FILE` là tùy chọn khai báo truyền vào trong images, trong trường hợp này là nơi mã hóa các mật khẩu đã được tạo ra ở trước đó.
  - `-e MYSQL_USER` là tùy chọn truyền vào tên của user cho mysql, có thể tùy ý nhập vào lựa chọn này.
  - `-e MYSQL_DATABASE` là trùy chọn truyền vào tên của database, có thể tùy ý nhập vào lựa chọn này.
  - `mysql:latest` là tên của images sẽ tạo ra container này.






























