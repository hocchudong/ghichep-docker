# 29. Container không thể truy cập Internet?
____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Có một vài lý do tại sao một container không thể truy cập internet nhưng chúng ta sẽ nói về iptables trong nội dung bài viết này.

- Docker có thể chạy trên hầu hết các nền tảng, nhưng chủ yếu tập trung vào việc chạy Docker trên máy chủ Linux và hầu như chỉ áp dụng cho việc sản xuất các sản phẩm (trái ngược với phát triển).

- Nếu bạn có đưa ra các rule iptables riêng, có thể bạn sẽ vô tình ghi đè lên những gì Docker đã đặt ra và điều đó sẽ mâu thuẫn với nhưng gì được quy định trong Docker.

- Docker sẽ liên kết với các rules iptables của bạn khi daemon Docker được khởi động cũng như khi các container đang chạy.

- Bạn có thể xác minh điều này bằng cách chạy:

        `sudo iptables -L`

    trên máy chủ Docker của bạn. Nếu bạn đã cài đặt Docker, bạn sẽ thấy tất cả các rules của Docker một cách cụ thể. Ngược lại, nếu bạn không nhìn thấy những quy tắc đó thì rất có thể bạn đã overwrote chúng.

- **Có thể khắc phục bằng cách khởi động lại Docker daemon**:
    +  Bạn có thể làm điều đó bằng cách chạy câu lệnh:

            sudo systemctl restart docker
            sudo service docker restart

        hoặc 

            sudo systemctl restart docker

        tùy thuộc vào phiên bản Linux mà bạn đang chạy.

        
____

# <a name="content-others">Các nội dung khác</a>
