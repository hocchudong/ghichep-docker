# Các ghi chép cần chú ý đối với docker

## Các thuật ngữ cần biết về container

- Docker là một ứng dụng
- Docker image: là mẫu (template) dùng để tạo ra các container.
- Container là một thể hiện của docker (gần bằng với các máy ảo). Docker container được chạy từ khởi tạo docker image
- Ngoài docker, có nhiều công cụ khác nhau có thể tạo ra các container ví dụ như: LXC, rkt
- Có 02 phiên bản chính của docker: 
	- Phiên bản thương mại: Enterprise Edition - Docker EE 
	- Phiên bản miễn phí:  Community Edition - Docker CE

## Thành phần của docker engine
![Các thành phần trong docker engine](/images/engine-components-flow.png)

## Các thành phần trong docker engine 
- Kiến trúc mức high level
![Mô hình kiến trúc của mức high level docker engine](/images/docker2.png)

## So sánh kiến trúc của LXC với Docker
- Từ bản 1.10 trở đi, docker sử dụng thư viện riêng để giao tiếp với kernel của Linux (trước đó sử dụng LXC)
![So sánh kiến trúc của LXC với docker](/images/linux-vs-docker-comparison-architecture-docker-lxc.png)

![So sánh kiến trúc của LXC với docker 2](/images/linux-vs-docker-comparison-architecture-docker-lxc_2.png)



## Tham khảo

1. https://sreeninet.wordpress.com/2015/02/02/containers-docker-lxc-and-rocket/

2. https://robinsystems.com/blog/containers-deep-dive-lxc-vs-docker-comparison/
