## Thực hành với docker swarm 

## MỤC LỤC

- 1. Sử dụng docker swarm để triển khai wordpress theo kiểu manual
- 2. Sử dụng docker swarm để triển khai wordpress có kết hợp docker-compose



### Yêu cầu
- Cần có môi trường cài đặt theo tài liệu [Cài đặt docker swarm](./docker-thuchanh-caidat-dockerswarm.md)
- Đảm bảo theo mô hình và kiểm tra hoạt động của docker swarm cơ bản thành công trước khi tiến hành các bài thực hành bên dưới.

#### 1. Sử dụng docker swarm để triển khai wordpress theo kiểu manual

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

- Tạo service chạy mysql.

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
  - `--network` là tên của network overlay vừa tạo ở bên trên, cần nhập đúng tên đã đặt ở bên trên, trong trường hợp này là `mysql_private`
  - `--secret` là tùy chọn khai báo cho mật khẩu của database đã tạo ở bước trên.
  - `-e MYSQL_ROOT_PASSWORD_FILE` và `-e MYSQL_PASSWORD_FILE` là tùy chọn khai báo truyền vào trong images, trong trường hợp này là nơi mã hóa các mật khẩu đã được tạo ra ở trước đó.
  - `-e MYSQL_USER` là tùy chọn truyền vào tên của user cho mysql, có thể tùy ý nhập vào lựa chọn này.
  - `-e MYSQL_DATABASE` là trùy chọn truyền vào tên của database, có thể tùy ý nhập vào lựa chọn này.
  - `mysql:latest` là tên của images sẽ tạo ra container này.



- Tạo service để chạy wordpress
  ```sh
  docker service create \
       --name wordpress \
       --network mysql_private \
       --publish 30000:80 \
       --secret source=mysql_password,target=wp_db_password \
       -e WORDPRESS_DB_HOST="mysql:3306" \
       -e WORDPRESS_DB_NAME="wordpress" \
       -e WORDPRESS_DB_USER="wordpress" \
       -e WORDPRESS_DB_PASSWORD_FILE="/run/secrets/wp_db_password" \
       wordpress:latest
  ```
  
Các tùy chọn gần tương tự như ta tạo service cho mysql ở trên, tuy nhiên cần lưu ý một số tùy chọn sau:
  - `--publish` là tùy chọn khai báo cho port để truy cập sau này từ bên ngoài vào trang wordpress.
  - `-e WORDPRESS_DB_HOST` là tùy chọn khai báo tên của service chạy mysql đã khai báo ở trước đó, trong trường hợp này tên là `mysql` và kèm theo port của mysql là `3306`.
  - `-e WORDPRESS_DB_NAME` và `-e WORDPRESS_DB_USER` là tên của database và user dành cho database đã được tạo trong service trước đó.
  - `wordpress:latest` tên của images để tạo ra container `wordpress`.



- Kiểm tra các service vừa tạo
  ```sh
  docker service ls
  ````
  - Kết quả sẽ liệt kê ra tên của các service vừa tạo ở trên.

- Kiểm tra chi tiết hơn về các service vừa tạo ở trên bằng lệnh `docker service ps ten_cua_service`

  ```sh
  docker service ps wordpress
  ```

  hoặc 

  ```sh
  docker service ps mysql
  ```

- Tới bước này đã có thể truy cập vào địa chỉ `http://ip_may_manager:30000` để tiếp tục sử dụng wordpress.

  
  
#### 2. Sử dụng docker swarm để triển khai wordpress có kết hợp docker-compose
- Kiểu triển khai này sẽ sử dụng một file template theo kiểu `yaml` mà docker hỗ trợ, có nghĩa là thay vì việc phải chạy lệnh hoặc script rời rạc thì ra sẽ biên soạn một file `yaml` theo quy ước để triển khai `wordpress` hoặc các ứng dụng của chúng ta.
- Trong ví dụ này sẽ sử dụng file `wordpress.yaml` để triển khai wordpress.
- Nếu trước đó đã tồn tại các service của `wordpress` mà docker-swarm tạo ra trước đó thì hãy dùng lệnh `docker service rm ten_service` để xóa trước khi thực hiện.

##### Bước 1: Tạo secret để cho các service sử dụng.

- Đứng tại node manager thực hiện các lệnh dưới để tạo file chứa mật khẩu của database 

  ```sh
  openssl rand -base64 20 > db_password.txt
  openssl rand -base64 20 > db_root_password.txt
  ```

- Lưu ý: File `db_password.txt` và `db_root_password.txt` sẽ được sử dụng trong file yaml bên dưới.

##### Bước 2: Tạo file có tên là `wordpress.yaml` chứa nội dung bên dưới.

- File dưới được soạn theo cú pháp của yaml, mục tiêu là tạo ra nội dung để docker-compose sử dụng. Nếu chưa rõ về cú pháp yaml và docker-compose thì hãy tìm hiểu thêm và đọc lại các tài liệu khác.

  ```sh
  version: '3.1'

  services:

    db:
      image: mysql:latest
      volumes:
        - db_data:/var/lib/mysql
      environment:
        MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_root_password
        MYSQL_DATABASE: wordpress
        MYSQL_USER: wordpress
        MYSQL_PASSWORD_FILE: /run/secrets/db_password
      secrets:
        - db_root_password
        - db_password

    wordpress:
      depends_on:
        - db
      image: wordpress:latest
      ports:
        - "8000:80"

      environment:
        WORDPRESS_DB_HOST: db:3306
        WORDPRESS_DB_USER: wordpress
        WORDPRESS_DB_PASSWORD_FILE: /run/secrets/db_password

      secrets:
      - db_password

  secrets:
    db_password:
      file: db_password.txt
    db_root_password:
      file: db_root_password.txt

  volumes:
    db_data:
  ```

Cấu trúc và nội dung của file `wordpress.yaml` như sau: 

  
##### Bước 3: Tạo stack (docker-compose) để 
- Sử dụng lệnh dưới để thực thi file `wordpress.yaml` để tạo ra stack có tên là `wpapp`

  ```sh
  docker stack deploy -c wordpress.yaml wpapp
  ```
  - Kết quả của lệnh trên sẽ trả về
    ```
    Creating network wpapp_default
    Creating secret wpapp_db_password
    Creating secret wpapp_db_root_password
    Creating service wpapp_db
    Creating service wpapp_wordpress
    ```
    
 Các service sẽ được tạo ra và kiểm tra bằng các lệnh dưới

- Kiểm tra xem stack có các service nào, trong ví dụ này sẽ là 02 service của `mysql` và `wordpress` như định nghĩa trong file `wordpress.yaml`
  ```sh
  docker stack ls
  ```

- Kiểm tra service đã được tạo 
  ```sh
  docker service ls
  ```
  
  hoặc
  
  ```sh
  docker stack services wpapp
  ```

  - Kết quả của lệnh `docker stack services wpapp`, trong đó `wpapp` là tên của stack được tạo ở bước 3.

    ```sh
    ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
    e9mhqq124syo        wpapp_db            replicated          1/1                 mysql:latest
    s9fiw47mvoxf        wpapp_wordpress     replicated          1/1                 wordpress:latest    *:8000->80/tcp
    ```
    - Trong kết quả này ta sẽ nhìn thấy port `8000` là port sẽ được sử dụng để truy cập vào wordpress.
    
- Kiểm tra trạng thái và thông tin cơ bản của các container trong service.

  ```sh
  docker stack ps wpapp
  ```
  - Trong đó `wpapp` là tên của stack được tạo ở bước 3

  - Kết quả
    ```
    ID                  NAME                    IMAGE               NODE                DESIRED STATE       CURRENT STATE           ERROR                       PORTS
    kq16n15kxd5v        wpapp_wordpress.1       wordpress:latest    srv3                Running             Running 2 minutes ago
    z7ujvhfl9b9w        wpapp_db.1              mysql:latest        srv2                Running             Running 2 minutes ago
    ```
    
- Tới bước này nếu các container đang hoạt động thì ta có thể truy câp với địa chỉ: `http://IP_node_bat_ky:8000` để bắt đầu sử dụng wordpress. 


- Để xóa stack vừa tạo ở trên ta sử dụng lệnh `docker stack rm wpapp`

















