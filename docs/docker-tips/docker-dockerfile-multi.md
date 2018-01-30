# 10. Sử dụng nhiều Dockerfile và Docker Compose cùng lúc

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

Khi nói đến tổ chức các dự án lớn hơn của bạn với Docker và Docker Compose có một số tùy chọn. Đây là cách tôi làm điều đó.

Các dự án nhỏ hơn có thể dễ dàng tổ chức được không? Bạn có 1 ứng dụng thường có một Dockerfile và `docker-compose.yml`.

- Tổ chức một dự án đơn giản với Docker trên hệ thống tệp tin của bạn có thể như sau:

        myapp/
          - appcode/
          - Dockerfile
          - docker-compose.yml

    nội dung của `docker-compose.yml` có thể bao gồm như sau:

        version: '3'

        services:
          myapp:
            build: '.'


    Nhưng những gì xảy ra khi bạn có một vài ứng dụng mà mỗi người có Dockerfile riêng của họ? Rất có thể bạn sẽ muốn có một tệp tin `docker-compose.yml` để kiểm soát toàn bộ ứng dụng và dịch vụ của bạn.

- **Dưới đây là cách tôi thường tổ chức các dự án dựa trên dịch vụ vi mô:**

        myapp/
          - auth/
            - Dockerfile
          - billing/
            - Dockerfile
          - contact/
            - Dockerfile
          - user/
            - Dockerfile
          - docker-compose.yml
    
    Trong trường hợp này, mỗi dịch vụ đều có Dockerfile riêng của mình vì mỗi ứng dụng riêng biệt đều thuộc cùng một dự án. Các dịch vụ này có thể được viết bằng bất kỳ ngôn ngữ nào , nó không quan trọng.

    - Tệp docker-compose.yml có thể giống như sau:

            version: '3'

            services:
              auth:
                build: './auth'
              billing:
                build: './billing'
              contact:
                build: './contact'
              user:
                build: './user'

        Đây chính là cách để build Dockerfile cho mỗi dịch vụ.


____

# <a name="content-others">Các nội dung khác</a>
