# 16. Chuyển hướng một file của container tới Docker Host

____
____

# <a name="content">Nội dung</a>

- > ![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Nội dung của bài viết nó về cách dump một file của container về Docker host.

- Khi ta muốn thực hiện debugging, bạn có thể muốn sao chép nội dung của một tệp tin cấu hình nằm bên trong một container tới Docker host của bạn để bạn có thể mở nó trong trình chỉnh sửa ưa thích hoặc gửi cho ai đó.

- Ta có thể thực hiện điều này bằng việc tận dụng 2 việc:

        # 1. Override a Docker image's CMD to cat the file you want.
        docker run --rm alpine cat /etc/hosts

    câu lệnh trên sẽ thực hiện hiển thị ra nội dụng của file `/etc/hosts`. Đây là một phần của giải pháp.

        # 2. Modify the command to redirect that output to a new file on your Docker host instead.
        docker run --rm alpine cat /etc/hosts > /tmp/alpinehosts

    bạn có thể xác nhận hoạt động bằng cách thực hiện sử dụng câu lệnh `ls -la /tmp | grep alpinehosts`.
    
____

# <a name="content-others">Các nội dung khác</a>
