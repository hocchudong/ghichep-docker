# B. Backup volumes trong Docker

____

# Mục lục


- [1. Tổng quan về kiến thức](#summary-about)
- [2. Backup và Restore volume.](#backup-volume)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="summary-about">1. Tổng quan về kiến thức</a>
    Volume trong Docker được dùng để chia sẻ dữ liệu cho container.
    - Để sử dụng volume trong docker dùng cờ hiệu (flag) -v hoặc (flag) --mount trong lệnh `docker run`.
    Có thể sử dụng Volume trong Docker trong những trường hợp sau
    - Chia sẻ giữa container và container.
    - Chia sẻ giữa container và host.

    > Trong nội dung của bài viết sẽ hướng dẫn sử dụng (flag) -v thay vì sử dụng (flag) --mount
    #### Sử dụng volume để gắn (mount) một thư mục nào đó trong host với container.
    - Ví dụ ta sẽ gắn một thư mục /var/datahost vào trong container.
    
        Bước 1: Tạo ra thư mục trên host
    
            mkdir /var/datahost

        Bước 2: Khởi tạo một container và chỉ ra volume được gắn
    
            docker run -it -v /var/datahost ubuntu
    
    - Ở ví dụ trên ta đã thực hiện gắn một thư mục vào trong một container. Ta có thể kiểm tra bằng việc tạo ra dữ liệu trên host và kiểm tra ở container hoặc ngược lại.


    #### Sử dụng volume để chia sẻ dữ liệu giữa host và container
    Trong tình huống này thư mục trên máy host (máy chứa container) sẽ được mount với một thư mục trên container, dữ liệu sinh ra trên thư mục được mount của container sẽ xuất hiện trên thư mục của host. 

    Ví dụ: Các bước như sau:

    - Tạo ra thư mục bindthis trên host, có đường dẫn /root/bindthis. 
    - Thư mục `/root/bindthis` này sẽ được mount với thư mục /var/www/html/webapp nằm trên container.
    - Tạo ra 1 file trong thư mục /var/www/html/webapp trên container.
    - Kiểm tra xem trong thư mục /root/bindthis trên host có hay không.

    ```sh
    root@compute3:~# mkdir bindthis
    root@compute3:~# ls bindthis/ 
    root@compute3:~# docker run -it -v $(pwd)/bindthis:/var/www/html/webapp ubuntu bash
    root@13aa90503715:/#
    root@13aa90503715:/# touch /var/www/html/webapp/index.html
    root@13aa90503715:/# exit
    exit
    root@compute3:~# ls bindthis/
    index.html
    root@compute3:~#
    ```

    - Có 2 chế độ chia sẻ volume trong docker, đó là read-write (rw) hoặc read-only (ro). Nếu không chỉ ra thì mặc định sử dụng chế độ read-write. Ví dụ chế độ read-only, sử dụng tùy chọn ro.

    ```sh
    docker run -it -v $(pwd)/bindthis:/var/www/html/webapp:ro ubuntu bash
    ```

    #### Sử dụng volume để chia sẽ dữ liệu giữa các container
    - Tạo container chứa volume 
    ```sh
    docker create -v /linhlt --name volumecontainer ubuntu
    ```

    - Tạo container khác sử dụng container `volumecontainer` làm volume. Khi đó, mọi sự thay đổi trên container mới sẽ được cập nhật trong container `volumecontainer`:
    ```sh
    docker run -t -i --volumes-from volumecontainer ubuntu /bin/bash
    ```

    Trong đó, tùy chọn `--volumes-from` chỉ ra tên của container sẽ được map volume.

- ### <a name="backup-volume">2. Backup và Restore volume.</a>
    - Backup:

    ```sh
    $ docker run --rm --volumes-from volumecontainer -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /linhlt
    ```

    - Lệnh này sẽ backup thư mục volume là `/linhlt` trong container `volumecontainer` và nén lại dưới dạng file `backup.tar`.

    - Restore:
    ```sh
    docker run -v /linhlt --name data-container ubuntu /bin/bash
    ```

    => Tạo volume /linhlt trên container `data-container`.

    ```sh
    $ docker run --rm --volumes-from data-container -v $(pwd):/backup ubuntu bash -c "cd /linhlt && tar -zxvf /backup/backup.tar"
    ```

    => Tạo container thực hiện nhiệm vụ giải nén file `backup.tar` vào thư mục `/linhlt`. Container này có liên kết với container `data-container` ở trên.

### Các chú ý về volume trong Docker
- Đường dẫn trong cờ hiệu `-v` phải là đường dẫn tuyệt đối, thường dùng `$(pwd)/ten_duong_dan` để chỉ đúng đường dẫn.
- Có thể chỉ định việc mount giữa thư mục trên host và thư mục trên container ở các chế độ read-wirte hoặc read-only, mặc định là read-write.
- Để chia sẻ volume dùng tùy chọn `--volumes-from`

____

# <a name="content-others">Các nội dung khác</a>
