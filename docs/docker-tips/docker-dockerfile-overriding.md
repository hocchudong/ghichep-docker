# 8. Ghi đè CMD trong Dockerfile

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

Nếu bạn đã xây dựng bất kỳ loại ứng dụng web thế giới thực nào, rất có thể bạn muốn chạy các dịch vụ khác nhau từ cùng một hình ảnh của Docker. Thì đây sẽ là cách thực hiện.

- Trước đó, chúng ta đã đề cập đến sự khác biệt giữa CMD và RUN trong một Dockerfile , và hôm nay tôi muốn bao gồm việc tận dụng hình ảnh Docker giống nhau cho nhiều dịch vụ. Điều này được thực hiện bằng cách ghi đè CMD mặc định trong Dockerfile của bạn.

- *Trước khi chúng ta đi vào vấn đề, hãy xem một trường hợp sử dụng rất phổ biến sau:*

    Giả sử, bạn có một tiêu chuẩn ứng dụng yêu cầu Ruby on Rails hoặc Flask/ Django. Nó bao gồm một cơ sở dữ liệu, máy chủ ứng dụng web của bạn và một background worker.

    Với **Rails**, có thể là `PostgreSQL`, Puma (máy chủ ứng dụng) và Sidekiq (background worker).
    Với **Flask** hoặc **Django**, đó có thể là `PostgreSQL`, `gunicorn` (máy chủ ứng dụng) và `Celery` (background worker).

    Rất có thể bạn có các ứng dụng Rails hoặc Flask/ Django đang chạy trong container của Docker, và bạn có một `Dockerfile` duy nhất.

    `Dockerfile` của bạn cũng có thể có một CMD - sẽ khởi chạy máy chủ ứng dụng của bạn ( Puma hoặc gunicorn ).
    
    Tuy nhiên, bạn cũng muốn chạy `background worker` tại container của mình. Bằng cách này, bạn có thể thực hiện tự động scale nó từ máy chủ ứng dụng web của bạn. Đây được coi là một phương pháp hay nhất.

    Docker làm điều này rất dễ dàng. Tất cả bạn phải làm là cung cấp một lệnh mới để chạy khi bạn khởi chạy Image của Docker, và nó sẽ ghi đè CMD trong Dockerfile của bạn.

- **Ví dụ (sử dụng Rails):**

    Câu lệnh cần thực hiện có thể là `bundle exec puma -C config/puma.rb`.

    Dưới đây là cách ghi đè bằng Docker Compose:

          website:
            build: .

          sidekiq:
            build: .
            command: sidekiq -C config/sidekiq.yml

    Đó là tất cả những gì nó có thể làm được. Bây giờ bạn có một dịch vụ hoàn toàn riêng biệt cho background worker của bạn và nó sẽ sử dụng Dockerfile giống như chính ứng dụng web của bạn. `command`: giá trị thuộc tính sẽ được ưu tiên hơn `CMD` của `Dockerfile` .

Tương tự như vậy có thể được thực hiện trên dòng lệnh bằng lệnh `docker run`. Bạn sẽ chỉ cung cấp lệnh tùy chỉnh ở cuối lệnh `docker run`. 

____

# <a name="content-others">Các nội dung khác</a>
