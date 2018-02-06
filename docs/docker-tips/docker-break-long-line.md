# 17. Break các dòng trong Dockerfile.

____
____

# <a name="content">Nội dung</a>

- > ![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Nội dung của bài viết sẽ nói về cách thực hiện `break long line` trong Dockerfile để có thể dễ dàng đọc hơn. 

- Trong Dockerfile, có thể bạn sẽ có các câu lệnh dài. Ví dụ như:

        RUN wget -O myfile.tar.gz http://example.com/myfile.tar.gz && tar -xvf myfile.tar.gz -C /usr/src/myapp && rm myfile.tar.gz

    thì ta có thể chia thành nhiều dòng nhỏ hơn như sau:

        RUN wget -O myfile.tar.gz http://example.com/myfile.tar.gz \
            && tar -xvf myfile.tar.gz -C /usr/src/myapp \
            && rm myfile.tar.gz

    ta nhận thấy rằng nó ngắn và dễ dàng đọc hơn so với cách trình bày trước đó. Ta cần phải kéo sang ngang để theo dõi nội dung của dòng lệnh.

- Việc thực hiện `break long line` được sử dụng bởi dấu `\` - backslash. Ta có thể sử dụng cách này cùng với nhiều chỉ dẫn lệnh khác trong Docker.



____

# <a name="content-others">Các nội dung khác</a>
