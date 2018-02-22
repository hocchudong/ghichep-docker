## Thực hành với docker swarm 



### Yêu cầu
- Cần có môi trường cài đặt theo tài liệu [Cài đặt docker swarm](./docker-thuchanh-caidat-dockerswarm.md)
- Đảm bảo theo mô hình và kiểm tra hoạt động của docker swarm cơ bản thành công trước khi tiến hành các bài thực hành bên dưới.

#### Sử dụng docker swarm để triển khai wordpress

- Tham khảo: http://www.cnblogs.com/CloudMan6/p/8098761.html

Chúng ta sẽ sử dụng docker swarm để triển khai wordpress trong các container. Kết quả sau khi triển khai ta sẽ có ứng dụng wordpress được triển khai trên docker swarm.

##### Tạo mật khẩu cho container bằng kỹ thuật `secret` trong docker.

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






























