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

## Mô hình kiến trúc của docker engine 
![Mô hình kiến trúc của docker engine](/images/docker2.png)

