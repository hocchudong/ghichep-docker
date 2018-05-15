# 27. Thiết lập một mật khẩu trên redis khi không có cấu hình tùy chỉnh
____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)


Có hai cách tiếp cận bạn có thể thực hiện:
    - **Custom images**

        + Bạn có thể thiết lập mật khẩu trong tệp `redis.conf` và sau đó xây dựng images Docker tùy chỉnh của riêng bạn bằng tệp cấu hình đó. Nó chắc chắn sẽ hoạt động nhưng bây giờ bạn phải chịu trách nhiệm quản lý custom image Docker đó.

        + Vì nó có mật khẩu dạng văn bản thuần nên rất có thể bạn muốn làm cho images đó trở nên riêng tư đồng nghĩa là bạn cần có `private repo` Docker Hub hoặc một `registry` riêng.

    - **Cấu hình custom volume**:
        + Vẫn tạo một redis.conf tùy chỉnh như trước nhưng mount volume vào image Redis chính thức. Điều này cũng hoạt động.

    - **Sử dụng tính năng ghi đè sử dụng CMD trong Docker Compose**:

        + Bạn có thể sử dụng Docker Compose dễ dàng để đặt mật khẩu mà không cần bất kỳ tập tin cấu hình nào khác. Nếu bạn không muốn sử dụng Docker Compose, bạn có thể thực hiện bằng cách chuyển qua lệnh tùy chỉnh vào cuối docker run (sử dụng --env).

        + Dưới đây là cách bạn thường sử dụng images Redis:

                 redis : 
                    image : ' redis:4-alpine' 
                    ports : 
                        - ' 6379:6379' 

        + Và đây là tất cả những gì bạn cần để thay đổi để thiết lập một mật khẩu tùy chỉnh:

                 redis : 
                    image : ' redis:4-alpine' 
                    command : redis-server --requirepass yourpassword 
                    ports : 
                        - ' 6379:6379' 

        + Mọi thứ sẽ khởi động bình thường và máy chủ Redis của bạn sẽ được bảo vệ bằng mật khẩu. 
            
____

# <a name="content-others">Các nội dung khác</a>
