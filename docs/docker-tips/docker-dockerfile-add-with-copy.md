# 2. Sự khác nhau giữa COPY và ADD trong Dockerfile

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- > Đôi khi bạn sẽ thấy có cả 2 chỉ dẫn lệnh COPY và ADD được sử dụng trong cùng một Dockerfile. Nhưng sẽ tới 99% bạn nên sử dụng COPY thay vì ADD. Tại sao lại như vậy?

- `COPY` và `ADD` cả hai đều là chỉ dẫn lệnh trong Dockerfile và có mục đích tương tự nhau. Chúng cho phép bạn copy files từ một vị trí được khai báo tới một Docker image.

- `COPY` lấy giá trị là *src* và *destination*. Nó chỉ cho phép bạn copy một local file hoặc trực tiếp từ local host (máy thực hiện building Docker image) tới chính bản thân của Docker image.

- `ADD` cũng cho phép bạn thực hiện giống như `COPY` nhưng còn hỗ trợ cả 2 loại source khác. Thứ nhất, bạn có thể sử dụng URL thay thế cho một local file/ đường dẫn. Thứ hai, bạn có thể thục hiện giải nén một file tar từ source một cách trực tiếp đến destination.

- Trong hầu hết các trường hợp, nếu bạn sử dụng một URL, bạn sẽ download một file zip và thực hiện sử dụng chỉ dẫn lệnh RUN để xử lý nó. Tuy nhiên, bạn cũng có thể sử dụng chỉ dẫn *RUN* với *curl* để thay thế cho chỉ dẫn `ADD`. Tuy nhiên, nên [gộp các chỉ dẫn lệnh](docker-dockerfile-chain-everything.md) RUN xử lý một mục đích lại để giảm kích thước của Docker Image.

- Trường hợp sử dụng hợp lệ của `ADD` là khi bạn muốn thực hiện giải nén một local tar file tới một đường dẫn khai báo trong Docker Image. Điều này là chính xác với những gì [Alpine Image](https://github.com/gliderlabs/docker-alpine/blob/c7368b846ee805b286d9034a39e0bbf40bc079b3/versions/library-3.5/Dockerfile) thực hiện với `ADD rootfs.tar.gz /`.

- Nếu bạn thực hiện copy local files tới Docker image thì hãy thường xuyên sử dụng `COPY` bởi vì nó tường minh hơn so với `ADD`.

____

# <a name="content-others">Các nội dung khác</a>
