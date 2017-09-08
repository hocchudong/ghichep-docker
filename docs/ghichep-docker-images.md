# docker mirror (docker images)

## Một số chú ý

- Docker image: là template để tạo ra các container. Tức là các container được chạy từ các images này.
- Có 02 cách để tạo ra các các mirror container
	- Cách 1: Tạo một container, chạy các câu lệnh cần thiết và sử dụng lệnh `docker commit` để tạo ra image mới. Cách này thường không được khuyến cáo.
	- Cách 2: Viết một `Dockerfile` và thực thi nó để tạo ra một images. Thường mọi người dùng cách này để tạo ra image.

- Khi một container được tạo từ đầu, nó sẽ kéo các image (pull) từ `Docker Hub` (Docker registry mặc định) về và thực tạo container từ image đó. 
- Tất cả mọi người đều có thể tạo ra các images.
- Docker hub có thành phần docker registry - được vận hành với công ty Docker, nơi đây chứa các images mà người dùng chia sẻ.
- Các image là dạng file-chỉ-đọc (read only file). Khi tạo một container mới, trong mỗi container sẽ tạo thêm một lớp có-thể-ghi được gọi là container-layer. Các thay đổi trên container như thêm, sửa, xóa file... sẽ được ghi trên lớp này. Do vậy, từ một image ban đầu, ta có thể tạo ra nhiều máy con mà chỉ tốn rất ít dung lượng ổ đĩa.
- Docker cung cấp 3 công cụ phân tán giúp chúng ta lưu trữ và quản lý các Docker image. Để tự dựng một private registry và lưu trữ các private image chúng ta có thể sử dụng một trong các công cụ sau:
  - Docker Registry: một open source image distribution tool giúp lưu trữ và quản lý image
  - Docker Trusted Registry: một công cụ trả phí, nó khác với Docker Registry là có giao diện quản lý và cung cấp một số tính năng bảo mật (nghe bảo thế)
  - Docker Hub: đây là một dịch vụ khi mà bạn không muốn tự quản lý registry. Cung cấp public và private image repository. Mặc định Docker Client sẽ sử dụng Docker Hub nếu không có registry nào được cấu hình. Trên này có rất nhiều các image offcial của các phần mềm như nginx, mongodb, mysql, jenkins,..

- Quy tắt đặt tên images: `[REPOSITORY[:TAG]]`
  - Trong đó, TAG là phiên bản của images. Mặc định, khi không khai báo tag thì docker sẽ hiểu tag là `latest`

## 1. Một số lệnh làm việc với images

### 1.1. Kiểm tra hoạt động của docker

- Sử dụng lệnh `docker run hello-world` để kiểm tra hoạt động của docker trên host.

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

### 1.2. Tìm kiếm immages từ Docker HUB

- Sử dụng lệnh `docker search` để tìm kiếm các images trên Docker HUB

	```sh
	docker search ubuntu
	```

- Hoặc tìm chính xác phiên bản

	```sh
	docker search ubuntu:14.04
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


- Kết quả của lệnh `docker search ubuntu:14.04`

	```sh
	root@u14-vagrant:~# docker search ubuntu:14.04
	NAME                                                DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
	saltstack/ubuntu-14.04-minimal                                                                      7                    [OK]
	saltstack/ubuntu-14.04                                                                              5                    [OK]
	simphonyproject/ubuntu-14.04-remote                 Ubuntu 14.04 with Remote Access Support (l...   1                    [OK]
	fernandoacorreia/ubuntu-14.04-oracle-java-1.7       Docker image with Ubuntu 14.04 and Oracle ...   1                    [OK]
	linuxmalaysia/docker-ubuntu-14.04-harden            Docker Ubuntu harden for security with SSH...   1                    [OK]
	widerplan/ubuntu-14.04                              Basic Ubuntu 14.04 builds with a few utili...   1                    [OK]
	breezeight/test-kitchen-ubuntu-14.04                Ubunti 14.04 with chef omnibus installed        1                    [OK]
	stevendgonzales/ubuntu-14.04-salt-minion            Ubuntu 14.04 with Salt-MInion                   0                    [OK]
	technopreneural/docker-ubuntu-14.04-bind9           Run DNS server using bind9 on Ubuntu 14.04      0                    [OK]
	technopreneural/docker-ubuntu-14.04-apache2         Apache2 on Ubuntu 14.04                         0                    [OK]
	syseleven/ubuntu-14.04-puppet3                      ubuntu-14.04-puppet3                            0                    [OK]
	technopreneural/docker-ubuntu-14.04-ruby            Ruby environment on Ubuntu 14.04                0                    [OK]
	thenewvu/ubuntu-14.04                               Ubuntu 14.04 + Nearby package repos             0                    [OK]
	simphonyproject/ubuntu-14.04-webapp                 Ubuntu 14.04 with backend framework suppor...   0                    [OK]
	libero18/ubuntu-14.04                                                                               0                    [OK]
	technopreneural/docker-ubuntu-14.04-php5            PHP5 environment on Ubuntu 14.04                0                    [OK]
	salttest/ubuntu-14.04                                                                               0                    [OK]
	technopreneural/docker-ubuntu-14.04-apt-cacher-ng   Run apt-cacher-ng on Ubuntu 14.04               0                    [OK]
	technopreneural/docker-ubuntu-14.04-mysql           MySQL on Ubuntu 14.04                           0                    [OK]
	seresearch/opendavinci-ubuntu-14.04                 Docker image with all Ubuntu 14.04 depende...   0                    [OK]
	zanox/kitchen-ubuntu-14.04                          Docker image for kitchen with ubuntu 14.04      0                    [OK]
	edentsai/ubuntu-14.04-openssh                       Official Ubuntu 14.04 LTS and OpenSSH serv...   0                    [OK]
	mba811/ubuntu-14.04                                 镜像ubuntu:14.04的容器                               0                    [OK]
	technopreneural/docker-ubuntu-14.04-puppetserver    Run puppetserver on Ubuntu 14.04                0                    [OK]
	simphonyproject/ubuntu-14.04-vncapp                 Ubuntu-14.04 with VNC application framework     0                    [OK]
	root@u14-vagrant:~#

	```

- Sau khi xác định được images muốn sử dụng, bạn sử dụng tiếp lệnh `docker pull` để kéo images từ internet về host cài docker của bạn. 

### 1.3. Tải images từ Docker Hub về host

- Ví dụ tải images có tên là `ubuntu` về host

	```sh
	docker pull ubuntu
	```

	```sh
	kết quả lệnh docker pull ubuntu
	```

- Để tạo một container từ image `ubuntu`, sử dụng lệnh `docker run ubuntu`

### 1.4. Kiểm tra các images tồn tại trên host.

- Sử dụng lệnh `docker images` để kiểm tra danh sách các images

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

### 1.5 Tạo container từ images 

- Trong các tài liệu thường hay sử dụng lệnh `docker run hello-world` để chạy một container, sau khi chạy xong container này nó sẽ thoát. Tuy nhiên, đa số chúng ta lại cần tương tác nhiều hơn nữa với container (thao tác nhiều hơn). 

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

- Có thể mở tab khác và sử dụng lệnh `docker events` để xem các thông tin về việc tạo container trong ví dụ trên (tab này cần được mở và chạy lệnh `docker events` trước khi thực hiện tạo container)

	```sh
	016-11-11T15:28:07.918591204+07:00 container start 4a7b498636b618728c7b00307708a0382bc0e6d7b28bba5534a91dfa30c46074 (image=ubuntu, name=goofy_hypatia)
	2016-11-11T15:28:07.921514758+07:00 container resize 4a7b498636b618728c7b00307708a0382bc0e6d7b28bba5534a91dfa30c46074 (height=32, image=ubuntu, name=goofy_hypatia, width=146)
	```


- Để thoát nhưng vẫn đảm bảo container được hoạt động, sử dụng tổ hợp phím `CTL + p`, sau đó `CTL + q`. Còn nếu thoát và dừng container thì sử dụng `CTL + c`
- Sử dụng lệnh `docker attach ID_Container` để truy cập vào container sử dụng.

	```sh
	root@u14-vagrant:~# docker attach 4a7b498636b6
	root@4a7b498636b6:/#
	root@4a7b498636b6:/#
	```

## 2. Push - Pull images using Docker Hub.
- Để push 1 image vừa tạo lên hub để chia sẻ với mọi người, thì ta cần tạo 1 tài khoản docker hub và login vào bằng câu lệnh
```sh
docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username:cosy294
Password:
Login Succeeded
```
- Sau khi login thành công ta tiến hành push image lên hub
```sh
$ docker push cosy294/test
The push refers to a repository [cosy294/test]
255c5f0caf9a: Image successfully pushed
```
  Trong đó: cosy294/test là tên images.
- Lưu ý: Nếu bạn muốn push images lên docker hub thì tên images phải có dạng: `cosy294/test`, trong đó **cosy294** là id dockerhub và **test** là tên repo.

- Để Pull một image từ Docker Hub: `docker pull {image_name}`

# 3. Create and use Docker Registry: Local Images Repo.
- Tạo môi trường chứa image. Docker đã hỗ trợ chúng ta cài đặt các môi trường này duy nhất trong 1 container. Rất là đơn giản, chúng ta chạy lệnh sau.
```sh
docker run -d -p 5000:5000 --name registry registry:2
```
- Khi đó, port 5000 sẽ được listen. Mọi thao tác pull, push image sẽ được thực hiện trên port này.

- Cấu hình docker để pull, push image từ registry vừa tạo: vi `/etc/default/docker`

```sh
DOCKER_OPTS="--insecure-registry 172.16.69.239:5000"
```
- Trong đó, `172.16.69.239` là địa chỉ ip máy chứa registry tạo ở trên.
- Sau khi cấu hình xong, ta khởi động lại docker
```sh
service docker restart
```
- Các thao tác pull và push image tương tự ở như là pull, push ở docker hub.