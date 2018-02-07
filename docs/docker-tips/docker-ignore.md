# 19. Phớt lờ các files trong Docker Images.
____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Nội dung bài viết nói về cách thực hiện bỏ qua các file hay thư mục nhất định khỏi Docker Images.

- Trong hầu hết các trường hợp, bạn sẽ sao chép trong mã nguồn của ứng dụng vào một Docker Images. Thông thường bạn sẽ làm điều đó bằng cách thêm `COPY src/ dest/` vào `Dockerfile` của bạn.

- Đó là một cách tuyệt vời để làm điều đó, nhưng việc thực hiện sẽ bao gồm những thứ như `.git/` hoặc thư mục `/tmp` thuộc dự án của bạn. Điều đó sẽ làm tăng kích thước của Docker Images.

- Để loại trừ các tập tin hay thư mục. Việc bạn phải làm là tạo tệp `.dockerignore` cùng với tệp `Dockerfile` của bạn.

- Ta có thể sử dụng các khai báo trong file `.dockerfileignore` để phớt lờ đi sự có mặt của các file đang có trong đường dẫn thực hiện build Docker. `.dockerfileignore` sử dụng `filepath.Math rules`. Ví dụ:

  */temp* có nghĩa là loại trừ các file và đường dẫn bắt đầu bằng temp hoặc sub-directory của root. Ví dụ sau đều có thể hiểu là một:

      - /subdir/temp

  hoặc 

      - /sbdir/temp.dump

  các file hoặc đường dẫn xuất hiện cụm từ `temp` đều được ignore.

        pattern:
        { term }

    term:

        '*'         matches any sequence of non-Separator characters
        '?'         matches any single non-Separator character
        '[' [ '^' ] { character-range } ']'
                    character class (must be non-empty)
        c           matches character c (c != '*', '?', '\\', '[')
        '\\' c      matches character c

    character-range:
    
        c           matches character c (c != '\\', '-', ']')
        '\\' c      matches character c
        lo '-' hi   matches character c for lo <= c <= hi

  dòng bắt đầu bằng ! có thể hiểu là tạo ra một ngoại lệ trong file. Ví dụ:

        *.md
        !README.md
    
  có thể hiểu là tất cả các file .md `đều không được sử dụng ngoại trừ file README.md`

____

# <a name="content-others">Các nội dung khác</a>
