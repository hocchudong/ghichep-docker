# 31. Làm thế nào để xóa bỏ `Dangling Images` trong Docker

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Nếu bạn đang làm việc với Docker, có thể bạn đã gặp thấy rất nhiều dữ liệu không có thật khi ta kiểm tra danh sách images. Thì đây sẽ là cách xử lý.

- Khi ta chạy câu lệnh:
        docker image ls
        
    ta có thể nhận thấy có một hoặc nhiều mục có `<none>`.

- Ví dụ như:
        
        REPOSITORY TAG    IMAGE ID     CREATED    SIZE
        <none>     <none> 7848fcc70e7b 4 days ago 362MB 
        
        
- Trong các phiên bản cũ hơn của Docker (và vẫn hoạt động), bạn có thể xóa `dangling images` bằng cách chạy câu lệnh:

        docker rmi -f $(docker images -f "dangling=true" -q)

    Nhưng với các phiên bản mới của Docker (1,13+), có một lệnh là:
    
        docker system prune
        
    sẽ không chỉ xóa `dangling images` mà còn loại bỏ tất cả các container bị dừng lại, tất cả các network không sử dụng bởi ít nhất 1 container, build cache, ...

Đây là câu lệnh bạn nên chạy thường xuyên. Hãy chạy nó trên một crontab.

____

# <a name="content-others">Các nội dung khác</a>
