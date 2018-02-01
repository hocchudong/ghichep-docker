# 12. Một trải nghiệm phát triển tốt hơn nhiều với volumes

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Nếu bạn đang tạo ứng dụng được viết bằng các ngôn ngữ động như Ruby, Python hoặc Node thì bạn nên sử dụng volumes trong phát triển.

- Ý tưởng phải xây dựng một images mới của Docker mỗi khi bạn thực hiện thay đổi cơ sở mã của ứng dụng dường như không hiệu quả lắm. Ngay cả với khả năng tuyệt vời của Docker để lưu trữ các lớp image sao cho nó chỉ cập nhật những gì đã thay đổi, nó sẽ vẫn gây phiền nhiễu khi xây dựng lại không ngừng.

- Rất may mắn cho chúng tôi, chúng tôi có thể sử dụng volumes để gắn kết trong code ứng dụng của chúng tôi trực tiếp vào một container đang chạy. Bằng cách này nếu chúng ta cập nhật cơ sở code của chúng tôi, thì những thay đổi sẽ có hiệu lực ngay lập tức.

- Đây là những gì sẽ cung cấp cho bạn cập nhật thời gian thực và tạo ra một trải nghiệm phát triển mà đối thủ tốc độ của những gì bạn sẽ nhận được mà không có Docker(with the [added win of using Docker](https://nickjanetakis.com/blog/docker-empowers-you-by-letting-you-use-the-best-tools-for-the-job))

- Bạn cũng có thể nhận được những gì tốt nhất của cả hai cách sử dụng COPY trong Dockerfile như thường lệ, nhưng khi đến thời điểm chạy các container của bạn trong quá trình phát triển, bạn chỉ cần thêm cờ volumes để khớp với đường dẫn của COPY, nó sẽ ghi đè bất cứ điều gì bạn đã sao chép.
    Ví dụ:

        # Dockerfile

        # Business like usual, copying in files to the Docker image.
        COPY . /app

    kém hiệu quả hơn

        # docker-compose.yml

        services:
          app:
            # Mount the current directory into `/app` inside the running container.
            volumes:
              - '.:/app'

- Bây giờ bạn đã có được các lợi ích về di chuyển khi sử dụng COPY (tạo ra các image Docker tự chứa mà bạn có thể phân phối tới các máy khác) trong sản phẩm và đồng thời bạn sẽ có được một môi trường phát triển nhanh chóng.
____

# <a name="content-others">Các nội dung khác</a>
