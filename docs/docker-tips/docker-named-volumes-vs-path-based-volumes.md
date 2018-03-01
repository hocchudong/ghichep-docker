# 28. Named Volumes và Path Based Volumes
____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Có hai cách để lưu và đồng bộ dữ liệu giữa một vùng chứa và máy chủ Docker của bạn. Hãy so sánh 2 cách này.

- **Named Volumes**: chẳng hạn như `postgres:/var/lib/postgresql/data`.
    Nếu bạn đang sử dụng Docker Compose, nó sẽ tự động tạo ra volumes cho bạn khi bạn thực hiện `docker-compose up` , nhưng nếu không bạn sẽ cần tự tạo nó bằng cách chạy `docker volume create postgres`.


    Khi bạn sử dụng một ổ đĩa như thế này, Docker sẽ quản lý volumes cho bạn. Trên Linux, volumes đó sẽ được lưu vào:

             `/var/lib/docker/volumes/postgres/_data`

        Nếu bạn đang chạy Windows hoặc MacOS, nó sẽ được lưu ở một nơi khác, nhưng bạn không cần phải lo lắng về nó. Bạn có thể quên nó, nhưng nó sẽ hoạt động ổn định trên tất cả các hệ thống.

- **Path based volumes**:  phục vụ cùng mục đích với `named volumes`, ngoại trừ bạn phải chịu trách nhiệm quản lý volumes được lưu trên máy chủ Docker. Ví dụ nếu bạn sử dụng:
        
        `./postgres:/var/lib/postgresql/data`

    thì thư mục:

        `postgres/`

    sẽ được tạo ra trong thư mục hiện tại trên máy chủ Docker.

- Bạn nên sử dụng loại nào?

    + Quay trở lại trước khi `named volumes` tồn tại, luôn luôn là một câu hỏi về nơi bạn nên lưu trữ các dữ liệu. Một số người đặt chúng vào một thư mục `data/` liên quan đến dự án của bạn. Những người khác đặt chúng vào `~/.docker-volumes`và điều này nhanh chóng trở nên kỳ quặc bởi vì bây giờ bạn đang viết volumes ra các khu vực của `file system` máy chủ lưu trữ của bạn mà không liên quan đến dự án.

    + Quy tắc chung của tôi là nếu bạn đang xử lý dữ liệu mà bạn không chủ động giao dịch trực tiếp thì hãy sử dụng `named volumes` và để cho Docker quản lý.

    + Tuy nhiên, nếu bạn đang sử dụng một volumes khi phát triển và bạn muốn mount với thư mục hiện tại để bạn có thể code của dự án mà không cần build lại sau đó có thể thực hiện bằng cách sử dụng một `path volumes` vì đó được coi là một cách tốt nhất.
____

# <a name="content-others">Các nội dung khác</a>
