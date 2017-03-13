# Các ghi chép cần chú ý đối với docker

# Ghi chú, từ mới

- Docker là một ứng dụng
- Docker image: là mẫu (template) dùng để tạo ra các container.
- Container là một thể hiện của docker (gần bằng với các máy ảo). Docker container được chạy từ docker image


## 1. Cài đặt

- Môi trường cài đặt: Ubuntu 14.04 64 bit
- Các bước cài đặt

	```
	sudo apt-get update
	sudo apt-get install apt-transport-https ca-certificates
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	```

- Tạo file `/etc/apt/sources.list.d/docker.list`

	```sh
	cat " deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
	```

- Chạy các lệnh dưới để tiếp tục cài đặt Docker

	```sh
	sudo apt-get update
	sudo apt-get purge lxc-docker
	apt-cache policy docker-engine
	apt-get upgrade

	sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
	sudo apt-get install docker-engine
	```

- Kiểm tra phiên bản `docker` sau khi cài đặt.

	```sh
	docker --version
	```

- Kiểm tra thử một container của docker bằng lệnh `docker run hello-world`. Kết quả là:

	```sh
	root@u14-vagrant:~# docker run hello-world
	Unable to find image 'hello-world:latest' locally
	latest: Pulling from library/hello-world

	c04b14da8d14: Pull complete
	Digest: sha256:0256e8a36e2070f7bf2d0b0763dbabdd67798512411de4cdcf9431a1feb60fd9
	Status: Downloaded newer image for hello-world:latest

	Hello from Docker!
	This message shows that your installation appears to be working correctly.

	To generate this message, Docker took the following steps:
	 1. The Docker client contacted the Docker daemon.
	 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
	 3. The Docker daemon created a new container from that image which runs the
	    executable that produces the output you are currently reading.
	 4. The Docker daemon streamed that output to the Docker client, which sent it
	    to your terminal.

	To try something more ambitious, you can run an Ubuntu container with:
	 $ docker run -it ubuntu bash

	Share images, automate workflows, and more with a free Docker Hub account:
	 https://hub.docker.com

	For more examples and ideas, visit:
	 https://docs.docker.com/engine/userguide/

	root@u14-vagrant:~#
	```

## 2. Các trạng thái cơ bản đối với Container trong Docker

- Tham khảo: https://docs.docker.com/engine/reference/api../hinhanh/event_state.png
- Kết hợp với lệnh `docker ps -a` để xem trạng thái của các container
- Danh sách các trạng thái cơ bản: 
	- `created`: Trạng thái của container đã được tạo.
	- `running`: Trạng thái đang chạy.
	- `pause` : Trạng thái đang tạm dừng.
	- `restarting`: Trạng thái khởi động lại container.
	- `exited`: Trạng thái này hiển thị sau trạng thái `stopped`, dùng để tách biệt với trạng thái đã được tạo nhưng chưa chạy lần nào.
	- `destroyed`: Trạng thái đã bị xóa bỏ và không tồn tại trên hệ thống.

- Có thể dùng lệnh `docker inspect ID_cua_Container` để xem trạng thái chi tiết của các container. 

	```sh
	docker inspect 951bfd6d073f
	```

	- Kết quả lệnh `docker inspect 951bfd6d073f` (kết quả đã được lược bỏ bớt, trạng thái lúc này là exited)

		```sh
		[
		    {
		        "Id": "951bfd6d073fe7502876d9842ebba76c9e2317bb25a5954b23004230491ecb22",
		        "Created": "2016-11-07T04:56:34.159173974Z",
		        "Path": "/hello",
		        "Args": [],
		        "State": {
		            "Status": "exited",
		            "Running": false,
		            "Paused": false,
		            "Restarting": false,
		            "OOMKilled": false,
		            "Dead": false,
		            "Pid": 0,
		            "ExitCode": 0,
		            "Error": "",
		            "StartedAt": "2016-11-07T04:56:34.512214065Z",
		            "FinishedAt": "2016-11-07T04:56:34.5504585Z"
		        },
		```

- Các status khác trong Docker: https://gist.github.com/congto/801ab5d28dfa15f13920aaa7a32bcce6


## 3. Thực hành về vòng đời chính của Container từ khi sinh ra đến khi mất đi

- Trong phần thực hành này sẽ hướng dẫn tạo một container với ứng dụng web server là Flask (một ứng dụng về website)

### 3.1. Thực hành tạo container

#### 3.1.1 Tạo container với tên là `web31`

- Lệnh dưới sẽ tạo một container có tên là `web31`

```sh
docker create --name web31 training/webapp python app.py
```

- Kết quả:

```sh
root@u14-vagrant:~# docker create --name web31 training/webapp python app.py
e6005cf723aa1b58886ded5221b7783d492851cdeafa985419671d9f56b07627
root@u14-vagrant:~#
```

#### 3.1.2. Kiểm tra trạng thái của container `web31`

```sh
docker inspect --format='{{.State.Status}}' web31

hoặc 

docker inspect -f={{.State.Status}} web31
```

#### 3.1.3. Khởi động container

```sh
root@u14-vagrant:~# docker start web31
web31
```

- Có thể kiểm tra lại trạng thái của container bằng lệnh `docker inspect -f={{.State.Status}} web31`. Lúc này trạng thái là `running`

#### 3.1.4. Tạm dừng một container

```sh 
docker pause web31
```

- Kiểm tra lại trạng thái của container vừa tạm dừng bằng lệnh `docker inspect -f={{.State.Status}} web31`. Lúc này trạng thái là `paused`

#### 3.1.5. Khởi động lại container sau khi pause (thực hiện unpause)

```sh
docker unpause web31
```

- Kiểm tra lại bằng lệnh `docker inspect -f={{.State.Status}} web31` sẽ thấy trạng thái là `running`

#### 3.1.6. Đổi tên container

```sh
docker rename web31 newweb31
```

- Kiểm tra lại trạng thái container vừa đổi tên từ `web31` sang `newweb31`

```sh
docker inspect -f={{.State.Status}} newweb31
```

#### 3.1.7. Sử dụng lệnh top trong container

```sh
root@u14-vagrant:~# docker top newweb31
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                4568                4553                0                   10:25               ?                   00:00:00            python app.py
```

#### 3.1.8. Kiểm tra log trong container

```sh
root@u14-vagrant:~# docker logs newweb31
 * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)
```

#### 3.1.9. Tạm dừng container

```sh
docker stop newweb31
```

- Kiểm tra trạng thái của container sau khi tạm dừng, lúc này sẽ thấy trạng thái là `exited`

```sh
root@u14-vagrant:~# docker inspect -f={{.State.Status}} newweb31
exited
```

#### 3.1.10. Xóa container 

```sh
root@u14-vagrant:~# docker rm newweb31
newweb31
root@u14-vagrant:~#
```

- Kiểm tra lại trạng thái của container vừa xóa, lúc này sẽ có thông báo với nội dung không tìm thấy container. `Error: No such image, container or task: newweb31` .

```sh
root@u14-vagrant:~# docker inspect -f={{.State.Status}} newweb31

Error: No such image, container or task: newweb31
```

### 3.2. Kết quả của toàn bộ các lệnh ở trên

```sh
root@u14-vagrant:~# docker create --name web31 training/webapp python app.py
e6005cf723aa1b58886ded5221b7783d492851cdeafa985419671d9f56b07627
root@u14-vagrant:~# docker inspect --format='{{.State.Status}}' web31
created

root@u14-vagrant:~# docker start web31
web31
root@u14-vagrant:~# docker inspect -f={{.State.Status}} web31
running

root@u14-vagrant:~# docker pause web31
web31
root@u14-vagrant:~# docker inspect -f={{.State.Status}} web31
paused

root@u14-vagrant:~# docker unpause web31
web31
root@u14-vagrant:~# docker inspect -f={{.State.Status}} web31
running

root@u14-vagrant:~# docker rename web31 newweb31
root@u14-vagrant:~# docker inspect -f={{.State.Status}} newweb31
running

root@u14-vagrant:~# docker top newweb31
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                4568                4553                0                   10:25               ?                   00:00:00            python app.py
root@u14-vagrant:~# docker logs newweb31
 * Running on http://0.0.0.0:5000/ (Press CTRL+C to quit)


root@u14-vagrant:~# docker stop newweb31

newweb31

root@u14-vagrant:~# docker inspect -f={{.State.Status}} newweb31
exited

root@u14-vagrant:~# docker rm newweb31
newweb31
root@u14-vagrant:~# docker inspect -f={{.State.Status}} newweb31

Error: No such image, container or task: newweb31
```


### 3.3 `docker stop` và `docker kill`

- Khi câu lệnh `docker stop` được thực hiện, nó sẽ gửi tới hệ thống một tín hiệu để xử lý tiến trình có PID=1, tín hiệu đó là SIGTERM (có ID = 15 - tham khảo tại https://sites.google.com/site/embedded247/escourse/lap-trinh-voi-tien-trinh-process). 

- Sau khi gửi tín hiệu SIGTERM xong, nó sẽ chờ container kết thức ứng dụng. Nếu thời gian chờ đợi container dừng ứng dụng vượt quá thời gian mặc định (mặc định là 10 giây - có thể điều chỉnh thời gian này)  thì docker sẽ tiếp tục gửi tín hiệu SIGKILL tới hệ thống. Lúc này ứng dụng sẽ bị hủy (cần lưu ý rằng SIGKILL sẽ gửi tín hiệu trực tiếp xuống kernel của hệ thống chứ không thông qua ứng dụng trong container)


- Giả sử thực hiện lệnh dưới, thực hiện tắt container sau 20 giây

```sh
docker stop ten_container -t 30
```

- Sau đó mở một tab khác và gõ `docker events`, bạn sẽ nhìn thấy các thông tin như bên dưới.

- Ví dụ: Thực hiện start một container, kiểm tra trạng thái và stop container đó với tùy chọn `-t 20`

```sh
root@u14-vagrant:~# docker start web31
web31
root@u14-vagrant:~# docker inspect -f={{.State.Status}} web31
running
root@u14-vagrant:~# docker stop web31 -t 20
web31
root@u14-vagrant:~#
````

- Mở một tab khác và quan sát kết quả của lệnh `docker events`

```sh
root@u14-vagrant:~# docker events
2016-11-11T11:26:04.389558534+07:00 container kill 95ee9e2c3ec83e6ca1a9145af507f42c2e7d29cef153263f1b2ad63ae0241d14 (image=training/webapp, name=web31, signal=15)
2016-11-11T11:26:24.397942170+07:00 container kill 95ee9e2c3ec83e6ca1a9145af507f42c2e7d29cef153263f1b2ad63ae0241d14 (image=training/webapp, name=web31, signal=9)
2016-11-11T11:26:24.474089688+07:00 container die 95ee9e2c3ec83e6ca1a9145af507f42c2e7d29cef153263f1b2ad63ae0241d14 (exitCode=137, image=training/webapp, name=web31)
2016-11-11T11:26:24.615183784+07:00 network disconnect 9e229d474aff61d687c0ccc1fea72f20ca37ca26695a733f42c6849a87fc72e6 (container=95ee9e2c3ec83e6ca1a9145af507f42c2e7d29cef153263f1b2ad63ae0241d14, name=bridge, type=bridge)
2016-11-11T11:26:24.693993648+07:00 container stop 95ee9e2c3ec83e6ca1a9145af507f42c2e7d29cef153263f1b2ad63ae0241d14 (image=training/webapp, name=web31)
```

- Minh họa: ![docker event](../hinhanh/docker1.png)

Trong hình trên, bạn sẽ nhìn thấy vào lúc `11:26:04` docker sẽ gửi một signal=15 (SIGTERM). Tới thời điểm `11:26:24` , tức là sau 20 giây, docker sẽ gửi tiếp một signal=9 (SGINKILL)



### 3.4. Copy dữ liệu từ host vào container và ngược lại.

### 3.5. DOCKER RUN

##4. Các thành phần cơ bản trong docker

![Các thành phần trong docker](../hinhanh/docker2.png)

Trong Docker có 03 thành phần chính:

1. `Client`: Thành phần phía người dùng : Người dùng sử dụng các công cụ dòng lệnh (CLI, API ...) được cung cấp bởi Docker để: `build`, upload images, thực hiện các câu lệnh để khởi tạo và quản lý các container

2. `Docker host`: Có nhiệm cụ download image từ Docker Registry và khởi động container khi có yêu cầu của người dùng.

3. `Docker Registry`: Là kho lưu trữ các image của docker, là nơi upload và download các image này.

**Các đối tượng chính:**
- Images: image được sử dụng để đóng gói ứng dụng và các thành phần phụ thuộc của ứng dụng. Image có thể được lưu trữ ở local hoặc trên một registry. Registry là một dịch vụ giúp tổ chức và cung cấp các kho chứa các image.
- Container: container là một running instance của một Docker Images. Nếu thấy quá khó hiểu bạn có thể liên tưởng nó với một virtual machine về mặt chức năng.
- Network: Cung cấp một private network mà chỉ tồn tại giữa container và host. Bắt đầu từ phiên bản 1.09 thì private network có thể mở rộng trên multi-host.
- Volume: volume được thiết kể để lưu trữ các dữ liệu độc lập với vòng đời của container.



## Các lệnh cơ bản với docker 

- Lệnh xem tất cả các container

	```sh
	docker ps -a
	```

- Lệnh xem các images 

	```sh
	docker images
	```

- Lệnh xem chi tiết container, image ..

	```sh
	docker inspect ID_container
	```

	- Ví dụ: https://gist.github.com/congto/4f943a6245c9f32cd1486aefd3d516f5

	- Sử dụng lệnh trên với tùy chọn -f 

		```sh
		docker inspect -f {{.Config.Hostname}} 951bfd6d073f
		```

- Lệnh xem các sự kiện của container 

	```sh
	docker evetns
	```

	- Lệnh dùng để xem các event xảy ra trong docker, cách thực hiện thì bạn có thể mở một tab mới và chạy `docker events`, tab khác thì thực hiện các lệnh trong docker.

- Lệnh `docker info` dùng để xem các thông tin về docker được cài trên host.

```sh
root@u14-vagrant:~# docker info
Containers: 4
 Running: 0
 Paused: 0
 Stopped: 4
Images: 3
Server Version: 1.12.3
Storage Driver: aufs
 Root Dir: /var/lib/docker/aufs
 Backing Filesystem: extfs
 Dirs: 27
 Dirperm1 Supported: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: host bridge overlay null
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Security Options: apparmor
Kernel Version: 3.19.0-25-generic
Operating System: Ubuntu 14.04.5 LTS
OSType: linux
Architecture: x86_64
CPUs: 4
Total Memory: 7.781 GiB
Name: u14-vagrant
ID: PCQB:PFMR:7FRY:FI4G:4HI3:CCIR:TRNO:XN47:4CK3:LBFJ:ZH7F:YNI5
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
WARNING: No swap limit support
Insecure Registries:
 127.0.0.0/8
root@u14-vagrant:~#

```


## Tham khảo: 
[1] http://www.cnblogs.com/sammyliu/p/5875470.html


