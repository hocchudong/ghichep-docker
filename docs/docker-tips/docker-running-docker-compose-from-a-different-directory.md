# 30. Chạy Docker Compose từ một thư mục khác
____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Thông thường khi bạn muốn tương tác với Docker Compose, bạn sẽ thực hiện `cd` vào thư mục của dự án là thư mục chứa tệp docker-compose.yml của bạn.

- Docker Compose có cung cấp flag `-f` cho phép bạn có thể bỏ qua vị trí của tệp docker-compose.yml (hoặc một tệp tùy chỉnh nếu bạn đặt tên cho nó ở một vị trí khác).

- Điều này có nghĩa là bạn có thể chạy:

        docker-compose -f /tmp/myproject/docker-compose.yml up -d

    từ bất cứ nơi nào trong `file system` của bạn và mọi việc sẽ làm việc như bình thường.
    
____

# <a name="content-others">Các nội dung khác</a>
