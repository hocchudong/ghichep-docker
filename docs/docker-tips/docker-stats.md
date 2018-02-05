# 21. Đánh giá tài nguyên của Docker container.

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Docker cung cấp một câu lệnh cho phép ta kiểm tra xem có bao nhiêu % của CPU, Memory hay I/O Network, ... đang được containers sử dụng.

- Việc cần làm đó là sử dụng câu lệnh:

        docker stats

    kết quả sẽ hiển thị tương tự như sau:

        CONTAINER     CPU %    MEM USAGE / LIMIT    MEM %  NET I/O          BLOCK I/O
        9c2f69f8631e  25.75%   5.188MiB / 5.877GiB  0.09%  6.32MB / 7.63MB  34.2MB / 37.5MB
        c6d1f0738982  0.29%    44.31MiB / 5.877GiB  0.74%  24.5kB / 4.99kB  26.5MB / 0B
        5a52bc636ec3  14.93%   948KiB / 5.877GiB    0.02%  4.79MB / 3.73MB  2.7MB / 0B
        f9f8d3140cd3  0.75%    27.59MiB / 5.877GiB  0.46%  26.1kB / 0B      14.8MB / 0B
        e60048f81636  137.01%  48.8MiB / 5.877GiB   0.81%  11.4MB / 11.1MB  41.3MB / 0B

- Có thể sử dụng thêm `--format` flag để giới hạn số cột được hiển thị khi sử dụng câu lệnh. Ví dụ:

        docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

    kết quả sẽ hiển thị tương tự như sau:

        CONTAINER           CPU %          MEM USAGE / LIMIT
        9c2f69f8631e        24.25%         5.203MiB / 5.877GiB
        c6d1f0738982        0.09%          42.78MiB / 5.877GiB
        5a52bc636ec3        14.66%         948KiB / 5.877GiB
        f9f8d3140cd3        0.74%          27.55MiB / 5.877GiB
        e60048f81636        134.69%        49.63MiB / 5.877GiB
        
____

# <a name="content-others">Các nội dung khác</a>
