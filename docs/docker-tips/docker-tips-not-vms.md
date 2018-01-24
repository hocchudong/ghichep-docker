# 1. Docker Containers là một tiến trình cô lập, không phải máy ảo.

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

> Có một số cách để hiểu rõ hơn về Docker Containers và có một cách để xác định Docker Containers không phải là gì?

- Một [Docker Container](https://nickjanetakis.com/blog/comparing-virtual-machines-vs-docker-containers) chỉ là một tiến trình/ dịch vụ đang chạy trực tiếp trên thiết bị của bạn. Nó hơi khác một chút so với các tiến trình khác bởi vì Docker daemon cùng với Linux kernel thực hiện một vài điều để đảm bảo nó chạy hoàn toàn trong việc bị cô lập.

- Không cần phải có mặt của bất kỳ máy ảo nào nếu như nền tảng của bạn có thể chạy Docker một cách tự nhiên. Docker daemon sẽ có trách nhiệm giữ tất cả các container của bạn chạy một cách an toàn trong việc bị cô lập.

- Một [Virtual Machine](https://nickjanetakis.com/blog/comparing-virtual-machines-vs-docker-containers) thường được sử dụng để cô lập toàn bộ một hệ thống. Nếu bạn sử dụng nhiều VMs để cô lập nhiều dịch vụ, bạn sẽ lãng phí nhiều tài nguyên hơn thay vì sử dụng Docker.


____

# <a name="content-others">Các nội dung khác</a>
