# 20. Sử dụng Docker mà không cần sudo trên Linux

____
____

# <a name="content">Nội dung</a>

- ![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Bài viết nói về việc quản lý Docker với một user không phải là root. Dưới đây sẽ là cách thực hiện:

- Theo mặc định khi cài Docker trên Linux. Ta chỉ có thể truy cập đến Docker daemon khi là người dùng `root` hoặc phải có thêm `sudo` trong các câu lệnh. Vậy khi ta không có quyền `root` thì phải làm như thế nào?

- *Hãy thêm một `docker group` và sau đó thêm user tới group đó:*

        sudo groupadd docker
        sudo usermod -aG docker $USER

    *hãy thực hiện đăng xuất ra khỏi Docker host và sau đó kiểm tra xem có hiệu lực hay chưa*.

____

# <a name="content-others">Các nội dung khác</a>
