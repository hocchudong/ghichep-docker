# Các ghi chép cần chú ý đối với docker

## Các thuật ngữ cần biết về container

- Docker là một ứng dụng
- Docker image: là mẫu (template) dùng để tạo ra các container.
- Container là một thể hiện của docker (gần bằng với các máy ảo). Docker container được chạy từ khởi tạo docker image
- Ngoài docker, có nhiều công cụ khác nhau có thể tạo ra các container ví dụ như: LXC, rkt
- Có 02 phiên bản chính của docker: 
	- Phiên bản thương mại: Enterprise Edition - Docker EE 
	- Phiên bản miễn phí: Community Edition - Docker CE

## Thành phần của docker engine
![Các thành phần trong docker engine](/images/engine-components-flow.png)

## Mô hình của docker
- Mô hình mức high level
![Mô hình kiến trúc của mức high level docker engine](/images/docker2.png)

## Workflow cơ bản của docker 

- Workflow làm việc của docker 
<img src="/images/docker-stages.png" align="middle" width="775" height="457"> 


## So sánh kiến trúc của LXC với Docker
- Từ bản 1.10 trở đi, docker sử dụng thư viện riêng để giao tiếp với kernel của Linux (trước đó sử dụng LXC)
![So sánh kiến trúc của LXC với docker](/images/linux-vs-docker-comparison-architecture-docker-lxc.png)

![So sánh kiến trúc của LXC với docker 2](/images/linux-vs-docker-comparison-architecture-docker-lxc_2.png)

## Trạng thái và chu trình của một container nói chung
- Sơ đồ thể hiện các trạng thái có thể có của container
![Trạng thái của container](/images/docker-state.jpg)

## Network trong Docker engine 
- Network trong container có giải pháp sẵn có và giải pháp tích hợp với các nền tảng khác.

- Mô hình network trong container 

![container-networking-model1](/images/Container_Networking_Model1.png)

- Giao tiếp giữa docker engine - libnetwork - driver

![container-networking-model2](/images/Container_Networking_Model2.png)

- Các loại driver network trong container

![container-networking-model3](/images/docker-native-model2.jpg)

### Đối với native driver network trong container
- Chiều outbound khi các container sử dụng trong container
![docker-network-native-outbound](/images/docker-native-network4.jpg)

Chiều inbound khi các container sử dụng trong container
![docker-network-native-inbound](/images/docker-native-network5.jpg)


#### Minh họa kết nối của các container trong docker native network
- Khi kết nối với card mạng docker0 (card mạng được sinh ra sau khi cài docker engine)
<img src="/images/docker-native-network1.jpg" align="middle" width="360" height="465"> 

- Khi kết nối với card mạng tạo thêm dành cho container và chỉ có kết nối nội bộ
<img src="/images/docker-native-network2.jpg" align="middle" width="360" height="465">

- Khi kết hợp giữa card mạng docker0 và card kết nối nội bộ các container 
<img src="/images/docker-native-network3.jpg" align="middle" width="360" height="465">

## Tham khảo

1. https://sreeninet.wordpress.com/2015/02/02/containers-docker-lxc-and-rocket/

2. https://robinsystems.com/blog/containers-deep-dive-lxc-vs-docker-comparison/
