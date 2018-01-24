# 5. Một số lợi ích khi sử dụng chung Base OS cho tất cả Images.

____
____

# <a name="content">Nội dung</a>

> ![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Docker sẽ thực hiện build images của bạn một cách an toàn nếu chúng có một OS riêng biệt, nhưng bạn có thể có được một vài điều hữu ích khi thực hiện sử dụng chung Base OS cho tất cả các Image.

- Trong nội dung của tips [Docker Image OS có cần phải phù hợp với Host OS?](docker-tips-math-os.md) đã có đề cập đến việc Docker Images không cần phải có OS phù hợp với Host OS. Nhưng lúc này thì lại nói về một điều gì đó khá là khác so với nội dung của tips trước đó (tips 4).

- Giả sử rằng một project của bạn bao gồm 3 dịch vụ:

    + PostgreSQL
    + Redis
    + A Flask web application

    Bạn có thể sẽ có 3 Docker Images riêng biệt và nó sẽ là một ý tưởng hay để tiếp cận với các Docker Image bao gồm: PostgreSQL, Redis, Python.

- ### Tiết kiệm không gian đĩa lưu trữ

    - Nếu bạn thực hiện lựa chọn Alpine như một base official images để thay thế cho cả 3 image bên trên, như vậy một bản sao của Alpine duy nhất sẽ được chia sẻ cho cả 3 Docker Image miễn là phiên bản của Alpine sẽ còn tiếp tục tăng lên. Đây là một cách rất hiệu quả để sử dụng không gian đĩa trên thiết bị của bạn. Và cũng có thể thực hiện theo [3. Gộp các chỉ dẫn lệnh RUN để có thể giảm kích thước của Docker Image](docker-dockerfile-chain-everything.md) để có thể tiết kiệm không gian đĩa.

    - Điều này sẽ đáng để chú ý hơn khi bạn sử dụng base OS khác nhau cho từng Docker Images, nhưng sau đó bạn sẽ mất khả năng sử dụng tính năng cache trên tất cả các hình ảnh. Tuy nhiên, việc thực hiện như này sẽ vẫn làm hoạt động bình thường.

- ### Dễ dàng hơn khi sử dụng Dockerfile

    - Nếu bạn kết hợp và so sánh base OS với từng Docker Image sau đó bạn sẽ cần phải nhớ khá là nhiều thông tin về công việc bạn đã làm.

    - Sau đó, bạn sẽ cần phải theo dõi thông tin cập nhật của các nhà phân phối, các trình quản lý packages có liên quan đến các base OS được sử dụng. Ví dụ: Debian sử dụng `apt` còn Alpine sử dụng `apk`. Vì thế mà tên của Packages cũng có thể sẽ khác nhau.

    - Nếu bạn thực hiện lựa chọn sử dụng duy nhất một base OS cho toàn bộ Docker Images, thì bạn sẽ luôn biết được những gì bạn đang làm việc với, và cần phải làm như thế nào, thực hiện ra làm sao mà không cần phải quan trọng đến việc nó có phải là Alpine hay không. Bạn chỉ cần lựa chọn 1 base OS duy nhất để sử dụng.

____

# <a name="content-others">Các nội dung khác</a>
