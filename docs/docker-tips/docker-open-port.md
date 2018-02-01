# 15. Mở và đóng port ra bên ngoài trong Docker

____
____

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Bạn có biết Docker hoạt động như một tường lửa cho các dịch vụ Dockerized của bạn? Bạn có thể kích hoạt hoặc vô hiệu hóa các dịch vụ của bạn bằng cách lắng nghe trên một cổng.

- Ví dụ: nếu bạn đang chạy máy chủ ứng dụng Flask, Node hoặc Rails, bạn có thể lắng nghe trên cổng 8000 và sau đó thiết lập nginx để proxy tới ứng dụng trên cổng 80 (http) và / hoặc 443 ( https ).

- **Nếu bạn không muốn máy chủ ứng dụng web của bạn được công khai** với thế giới bên ngoài thì hãy thêm cờ này vào lệnh `run` của bạn: `-p 8000:8000` nó sử dụng định dạng `HOST:CONTAINER` và sẽ ràng buộc cổng của container vào máy chủ lưu trữ trên các cổng mà bạn chỉ định, và điều này sẽ làm cho nó có thể tiếp cận với thế giới bên ngoài. Nếu bạn cung cấp `-p 8000` nó sẽ bị ràng buộc vào máy chủ trên một cổng ngẫu nhiên.

- **Nếu bạn muốn máy chủ ứng dụng web của bạn KHÔNG được công khai** với thế giới bên ngoài nhưng vẫn có thể truy cập được đến các container khác trong cùng một mạng (như nginx trong ví dụ này) thì bạn phải `bỏ qua cờ -p` . Các container trên cùng một mạng sẽ vẫn có thể tiếp cận với nhau trên bất kỳ cổng nào mà chúng có thể bị ràng buộc.

____


# <a name="content-others">Các nội dung khác</a>
