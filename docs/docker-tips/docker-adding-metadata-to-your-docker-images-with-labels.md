# 25. Thêm metadata tới docker images sử dụng `--labels`

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Labels cho phép bạn làm những điều khá thú vị với images của Docker. Đây là một vài trường hợp sử dụng cơ bản.

- labels images cho phép bạn đính kèm dữ liệu loại văn bản vào các images Docker của bạn. Sau đó, bạn có thể filter images dựa trên các labels này.

- Dưới đây là một vài ví dụ về những gì bạn có thể sử dụng labels cho images:

    + **Lưu trữ thông tin build**: chẳng hạn như git tags, ngày phát hành
    + **Credit images**
    + **Hiển thị thông tin về bản quyền, giấy phép, ...**
    + **Tổ chức images theo một tiêu chí nào đó**

- Một cách để thực hiện là thêm chỉ dẫn lệnh `LABEL` vào `Dockerfile` của bạn. Định dạng là: 

        LABEL <key>=<value> 

    và bạn có thể thêm nhiều hơn một chỉ dẫn lệnh trên.

- Ví dụ:

        LABEL version="1.0" maintainer="Nick Janetakis <nick.janetakis@gmail.com>" 


- Một cách khác nữa đó là sử dụng flag `--label` như sau:

        docker build <key>=<value> --label <key>=<value> --label <key>=<value>

- Ví dụ:

        # This expects you to have a Dockerfile in the current directory. 
        docker build . --label "version=1.0" --label "maintaner=Nick Janetakis <nick.janetakis@gmail.com>" 
       
____

# <a name="content-others">Các nội dung khác</a>
