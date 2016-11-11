# docker mirror (docker images)

## Một số chú ý

- Docker image: là template để tạo ra các container. Tức là các container được chạy từ các images này.
- Có 02 cách để tạo ra các các mirror container
	- Cách 1: Tạo một container, chạy các câu lệnh cần thiết và sử dụng lệnh `docker commit` để tạo ra image mới. Cách này thường không được khuyến cáo.
	- Cách 2: Viết một `Dockerfile` và thực thi nó để tạo ra một images. Thường mọi người dùng cách này để tạo ra image.

- Khi một container được tạo từ đầu, nó sẽ kéo các image (pull) từ `Docker Hub` (Docker registry) về và thực tạo container từ image đó. 
- Tất cả mọi người đều có thể tạo ra các images.
- Docker hub có thành phần docker registry - được vận hành với công ty Docker, nơi đây chứa các images mà người dùng chia sẻ.


##1. Một số lệnh làm việc với images

###1.1. Kiểm tra hoạt động của docker

	```sh
	docker run hello-world
	```

- Lệnh trên sẽ gọi tới image tên là hello-world, đây là một image được lưu trên Docker Hub. Mục tiêu của image này là để kiểm tra hoạt động của docker được cài trên host đã ổn hay chưa.


- Kết quả như sau chứng tỏ docker đã hoạt động ổn định

	```sh
	root@u14-vagrant:~# docker run hello-world

	Hello from Docker!
	This message shows that your installation appears to be working correctly.
	....
	```

###1.2. Tìm kiếm immages từ Docker HUB

	```sh
	docker search ubuntu
	```

- Lệnh này sẽ thực hiện tìm kiếm images có tên là `ubuntu` từ internet, kết quả sẽ trả về các images có tên là `ubuntu`

	```sh
	root@u14-vagrant:~# docker search ubuntu
	NAME                       DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
	ubuntu                     Ubuntu is a Debian-based Linux operating s...   5019      [OK]
	ubuntu-upstart             Upstart is an event-based replacement for ...   68        [OK]
	rastasheep/ubuntu-sshd     Dockerized SSH service, built on top of of...   49                   [OK]
	consol/ubuntu-xfce-vnc     Ubuntu container with "headless" VNC sessi...   29                   [OK]
	ubuntu-debootstrap         debootstrap --variant=minbase --components...   27        [OK]
	torusware/speedus-ubuntu   Always updated official Ubuntu docker imag...   27                   [OK]
	ioft/armhf-ubuntu          [ABR] Ubuntu Docker images for the ARMv7(a...   19                   [OK]
	nickistre/ubuntu-lamp      LAMP server on Ubuntu                           10                   [OK]
	nuagebec/ubuntu            Simple always updated Ubuntu docker images...   9                    [OK]
	nimmis/ubuntu              This is a docker images different LTS vers...   5                    [OK]
	maxexcloo/ubuntu           Base image built on Ubuntu with init, Supe...   2                    [OK]
	jordi/ubuntu               Ubuntu Base Image                               1                    [OK]
	darksheer/ubuntu           Base Ubuntu Image -- Updated hourly             1                    [OK]
	admiringworm/ubuntu        Base ubuntu images based on the official u...   1                    [OK]
	1and1internet/ubuntu-16    Ubuntu 16 Base Image                            1                    [OK]
	lynxtp/ubuntu              https://github.com/lynxtp/docker-ubuntu         0                    [OK]
	datenbetrieb/ubuntu        custom flavor of the official ubuntu base ...   0                    [OK]
	labengine/ubuntu           Images base ubuntu                              0                    [OK]
	webhippie/ubuntu           Docker images for ubuntu                        0                    [OK]
	vcatechnology/ubuntu       A Ubuntu image that is updated daily            0                    [OK]
	esycat/ubuntu              Ubuntu LTS                                      0                    [OK]
	konstruktoid/ubuntu        Ubuntu base image                               0                    [OK]
	widerplan/ubuntu           Our basic Ubuntu images.                        0                    [OK]
	ustclug/ubuntu             ubuntu image for docker with USTC mirror        0                    [OK]
	teamrock/ubuntu            TeamRock's Ubuntu image configured with AW...   0                    [OK]
	root@u14-vagrant:~#
	```

- Trong đó:
	- Cột `NAME` : tên của images
	- Cột `DESCRIPTION`: Mô tả ngắn gọn của images 
	- Cột `OFFICIAL`: Là images chính thức do công ty Docker cung cấp. Trạng thái là OK.

- Sau khi xác định được images muốn sử dụng, bạn sử dụng tiếp lệnh `docker pull` để kéo images từ internet về host cài docker của bạn. 

###1.3. Tải images từ Docker Hub về host

- Ví dụ tải images có tên là `ubuntu` về host

	```sh
	docker pull ubuntu
	```

	```sh
	kết quả lệnh docker pull ubuntu
	```

- Để tạo một container từ image `ubuntu`, sử dụng lệnh `docker run ubuntu`

###1.4. Kiểm tra các images tồn tại trên host.

	```sh
	docker images
	```

- Kết quả: 

	```sh
	root@u14-vagrant:~# docker images
	REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
	ubuntu              latest              f753707788c5        4 weeks ago         127.2 MB
	hello-world         latest              c54a2cc56cbb        4 months ago        1.848 kB
	training/webapp     latest              6fae60ef3446        18 months ago       348.8 MB
	root@u14-vagrant:~#
	```

###1.5 Tạo container từ images 

- Trong các tài liệu thường hay sử dụng lệnh `docker run hello-world` để chạy một container, sau khi chạy xong container này nó sẽ thoát. Tuy nhiên, đa số chúng ta lại cần làm việc với container (thao tác nhiều hơn). 

- Để chạy container và tương tác với container ta sử dụng tùy chọn `-it` trong lệnh `docker run`. Ví dụ:


	```sh
	docker run -it ubuntu
	```

- Kết quả:

	```sh
	root@u14-vagrant:~# docker run -it ubuntu

	root@4a7b498636b6:/# cat /etc/*release
	DISTRIB_ID=Ubuntu
	DISTRIB_RELEASE=16.04
	DISTRIB_CODENAME=xenial
	DISTRIB_DESCRIPTION="Ubuntu 16.04.1 LTS"
	NAME="Ubuntu"
	VERSION="16.04.1 LTS (Xenial Xerus)"
	ID=ubuntu
	ID_LIKE=debian
	PRETTY_NAME="Ubuntu 16.04.1 LTS"
	VERSION_ID="16.04"
	HOME_URL="http://www.ubuntu.com/"
	SUPPORT_URL="http://help.ubuntu.com/"
	BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
	UBUNTU_CODENAME=xenial
	root@4a7b498636b6:/#
	```

- Trong ví dụ trên, lệnh `docker run -it ubuntu` sẽ tạo một container từ image có tên là `ubuntu` và tương tác luôn với nó. Lệnh `cat /etc/*release` sẽ hiển thị phiên bản container ở trên. Số `4a7b498636b6` là ID của container 

- Có thể mở tab khác và sử dụng lệnh `docker events` để xem các thông tin về việc tạo container trong ví dụ trên

	```sh
	016-11-11T15:28:07.918591204+07:00 container start 4a7b498636b618728c7b00307708a0382bc0e6d7b28bba5534a91dfa30c46074 (image=ubuntu, name=goofy_hypatia)
	2016-11-11T15:28:07.921514758+07:00 container resize 4a7b498636b618728c7b00307708a0382bc0e6d7b28bba5534a91dfa30c46074 (height=32, image=ubuntu, name=goofy_hypatia, width=146)
	```

