# 34. Sự khác nhau giữa RUN và CMD trong Dockerfile

____

# Mục lục


- [1.1 Nhắc lại kiến thức](#review)
    - [1.1.2 Câu lệnh RUN](#cmd-run)
    - [1.1.1 Câu lệnh CMD](#cmd-cmd)
- [1.2 Sự khác nhau giữa RUN và CMD](#main-content)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="review">1.1 Nhắc lại kiến thức</a>

    - `RUN` và `CMD` là 2 chỉ dẫn lệnh được sử dụng thường xuyên trong Dockerfiles. Cả hai đều có chức năng tạo ra các chỉ dẫn lệnh để hướng dẫn Docker chạy câu lệnh cần thiết khi thực hiện các công việc để build containers.

    - ### <a name="cmd-run">1.1.2 Câu lệnh RUN</a>

        - Trong Dockerfiles, RUN có 2 khuôn mẫu để sử dụng:

                RUN <command>

                # shell form, các câu lệnh sẽ chạy trong shell, mặc định là `/bin/sh -c` trên Linux hoặc `cmd /s /c` trên Windows.

            hoặc

                RUN ["executable", "param1", "param2"]

                # exec form

        - Chỉ dẫn RUN sẽ thực thi câu lệnh trong layer mới nằm trên images hiện đang sử dụng và commit kết quả. Kết quả là images đã được commit sẽ được sử dụng trong bước tiếp theo được khai báo trong Dockerfiles

        - Việc phân lớp chỉ dẫn lệnh RUN và tạo ra các commit phù hợp với các khái niệm cốt lõi trong Docker để đảm bảo có thể biết được đâu là commit ít thay đổi và containers có thể được tạo ra từ bất kỳ từ một vị trí nào của history images.

        - `exec form` được sử dụng để đảm báo tránh `shell strings munging`, các chỉ dẫn lệnh RUN sử dụng một base image mà không chứa shell có thể thực thi.

        - `shell form` với chỉ dẫn lệnh RUN có thể được sử dụng thay thế bởi chỉ dẫn lệnh SHELL. Trong `shell form`, ta có thể sử dụng thêm ký tự ` \ ` để chia các câu lệnh dài thành các câu lệnh ngắn hơn trên một dòng. Ví dụ:

                RUN /bin/bash -c 'source $HOME/.bashrc; \
                echo $HOME'

            khai báo này tương tự với:

                RUN /bin/bash -c 'source $HOME/.bashrc; echo $HOME'

        - Để sử dụng một shell thực thi khác, ta cần phải sử dụng `exec form` để khai báo. Ví dụ:

                RUN ["/bin/bash", "-c", "echo hello"]

        - Không giống như `shell form`, `exec form` sẽ không invoke một câu lệnh shell và phân tích cú pháp như một JSON array (có nghĩa là chỉ được dùng ký tự ` " ` để khai báo). Điều này có nghĩa là các xử lý shell bình thường sẽ không xảy ra. Ví dụ:

                RUN [ "echo", "$HOME" ]

            sẽ không làm thay đổi biến môi trường `$HOME`. Nếu muốn shell xử lý thì phải sử dụng `shell form` hoặc khai báo thêm trình thực thi `shell` trực tiếp vào câu lệnh.

                RUN [ "sh", "-c", "echo $HOME" ]

        - Trong một Dockerfile có thể sử dụng nhiều khai báo chỉ dẫn lệnh RUN.

    - ### <a name="cmd-cmd">1.1.1 Câu lệnh CMD</a>

        - Trong Dockerfiles có thể sử dụng CMD với ba khuôn mẫu như sau:

                CMD ["executable","param1","param2"]

                # `exec form`, được sử dụng phổ biến

            hoặc

                CMD ["param1","param2"]

                # tham số mặc định tới ENTRYPOINT

            hoặc

                CMD command param1 param2

                # `shell form`. Mặc định sẽ thực thi trong `/bin/sh -c`

        - Mục đích chính của `CMD` là để cung cấp mặc định cho một container thực thi. Mặc định có thể bao gồm một file thực thi, trong trường hợp ta khai báo chỉ dẫn `ENTRYPOINT`.

        - Nếu CMD được sử dụng để cung cấp các đối số mặc định cho ENTRYPOINT thì cả ENTRYPOINT và CMD nên được khai báo với định dạng JSON array.

        - Khi sử dụng `exec form` hoặc `shell form` thì CMD sẽ tập hợp các câu lệnh để có thể thực thi khi chạy image.

        - Nếu ta muốn chạy `<command>` bên ngoài shell thì ta phải trình bày câu lệnh như một JSON array và khai báo đầy đủ đường dẫn tới trình thực thi. Ví dụ:

                FROM ubuntu
                CMD ["/usr/bin/wc","--help"]

        - Trong một Dockerfile, ta chỉ có thể sử dụng một chỉ dẫn lệnh CMD. Nếu có nhiều hơn một chỉ dẫn CMD. Thì chỉ dẫn CMD khai báo cuối cùng sẽ đước sử dụng.

- ### <a name="main-content">1.2 Sự khác nhau giữa RUN và CMD</a>

    - Qua tìm hiểu về nội dung, mục đích của RUN và CMD trong Dockefile, ta nhận thấy được rằng chỉ dẫn RUN và chỉ dẫn CMD đều cho phép ta thực thi một câu lệnh. Vậy khi nào thì ta sử dụng chỉ dẫn RUN, khi nào thì ta sử dụng chỉ dẫn CMD?

    - Về cơ bản, hai chỉ dẫn có sự khác nhau như sau:

        + RUN được thực thi trong quá trình build. Khi ta build một Docker image, Docker sẽ đọc các câu lệnh trong chỉ dẫn RUN và build tới một layer mới trong image sử dụng.

        + CMD được thực thi trong quá trình run. Điều này cho phép gọi tới một vài quá trình như bash, nginx hay bất cứ quá trình nào mà Docker image runs. Việc thực thi chỉ dẫn nằm ngay trong layer hiện tại của images.

        + Trong Dockerfile có thể có nhiều chỉ dẫn RUN được thực thi nhưng chỉ có duy nhất một chỉ dẫn CMD được thi.

____

# <a name="content-others">Các nội dung khác</a>

- [Docker Tip #36: The Difference between RUN and CMD in a Dockerfile — Nick Janetakis](https://nickjanetakis.com/blog/docker-tip-36-the-difference-between-run-and-cmd-in-a-dockerfile)