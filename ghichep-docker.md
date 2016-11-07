# Các ghi chép cần chú ý đối với docker

## Cài đặt

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

## Các trạng thái cơ bản đối với Container trong Docker

- Tham khảo: https://docs.docker.com/engine/reference/api/images/event_state.png
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

## Các lệnh cơ bản với docker 

- Lệnh xem tất cả các container

```sh
docker ps -a
```

- Lệnh xem các images 

```sh
docker images
```