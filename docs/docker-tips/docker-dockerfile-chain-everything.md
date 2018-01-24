# 3. Gộp các chỉ dẫn lệnh RUN để có thể giảm kích thước của Docker Image

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

> Mọi thứ bạn thực hiện trong Dockerfile khi build Docker image có thể làm cho kích thước của image trở lên cồng kềnh. Đây sẽ là một gọi ý nhỏ để giảm bớt kích thước của Image lại.

- Có rất nhiều cách để làm giảm kích thước của một image nhưng cách dễ nhất để thực hiện đó là tận dụng cơ chế caching trong khi building image của Docker.

- Hãy cùng quan sát ví dụ sau đây để có thể bắt đầu hiểu rõ vấn đề đang được đề cập đến:

    Trong Dockerfile, bạn muốn thực hiện 3 hành động sau:

    1. Sử dụng wget để download một file zip từ một nơi nào đó.
    2. Giải nén file zip vừa download trực tiếp đến một thư mục nào đó.
    3. Loại bỏ file zip khi không cần đến nó nữa.

    Bạn có thể thực hiện nó bằng một cách kém hiệu quả bằng việc thực hiện như sau trong Dockerfile:

        RUN wget -O myfile.tar.gz http://example.com/myfile.tar.gz
        RUN tar -xvf myfile.tar.gz -C /usr/src/myapp
        RUN rm myfile.tar.gz

- Nó sẽ làm tăng kích thước của Image bạn sẽ build ra vì sẽ có 3 layer riêng biệt được tạo ra do có 3 chỉ dẫn lệnh RUN được chạy và file `myfile.tar.gz` là một phần của image làm tăng kích thước của image khi bạn không cần sử dụng đến nó.

- Để khắc phục, bạn hãy thế 3 chỉ dẫn lệnh RUN trên bằng một chỉ dẫn lệnh RUN duy nhất như sau:

        RUN wget -O myfile.tar.gz http://example.com/myfile.tar.gz \
        && tar -xvf myfile.tar.gz -C /usr/src/myapp \
        && rm myfile.tar.gz

- Điều này sẽ đảm bảo chất lượng hiệu quả hơn so với trước đó. Docker sẽ chỉ tạo ra 1 layer duy nhất mà vẫn đảm bảo được mục đích thực hiện được đề ra. Thậm chí, còn có thể giúp bạn build image nhanh hơn do việc build phải trả qua ít layer hơn.
____

# <a name="content-others">Các nội dung khác</a>
