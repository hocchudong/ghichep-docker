# Hướng dẫn cài đặt Docker
## Cài đặt docker engine
### Cài bản stable mới nhất
- Các OS áp dụng: CentOS 7.3 64bit, Ubuntu 14.04 64bit, Ubuntu 16.04 64bit
- Đăng nhập với quyên `root` và thực hiện lệnh dưới để cài đặt. Đảm bảo máy có kết nối internet.
	```sh
	su - 
	
	curl -sSL https://get.docker.com/ | sudo sh
	```
	- Kết quả của lệnh trên như bên dưới
		```sh
			If you would like to use Docker as a non-root user, you should now consider
		adding your user to the "docker" group with something like:

			sudo usermod -aG docker your-user

		Remember that you will have to log out and back in for this to take effect!

		WARNING: Adding a user to the "docker" group will grant the ability to run
						 containers which can be used to obtain root privileges on the
						 docker host.
						 Refer to https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
						 for more information.
		```

- Thực hiện lệnh dưới để phân quyền cho user hiện tại thuộc group `docker`
	```sh
	sudo usermod -aG docker `whoami`
	```

- Kích hoạt docker sau khi cài đặt xong và cho phép khởi động cùng OS
	```sh
	systemctl start docker.service
	systemctl enable docker.service
	```

- Kiểm tra trạng thái của docker sau khi khởi động
	```sh
	systemctl status docker.service
	```
	- Kết quả lệnh trên như dưới là ok
		```sh
		docker.service - Docker Application Container Engine
			 Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
			 Active: active (running) since Wed 2017-09-06 21:54:07 +07; 31s ago
				 Docs: https://docs.docker.com
		 Main PID: 2194 (dockerd)
			 CGroup: /system.slice/docker.service
							 ├─2194 /usr/bin/dockerd
							 └─2200 docker-containerd -l unix:///var/run/docker/libcontainerd/docker-containerd.sock --metrics-interval=0 --start-timeout 2m --state-dir /var/run/do...

		Sep 06 21:54:05 docker1 dockerd[2194]: time="2017-09-06T21:54:05.324752580+07:00" level=warning msg="failed to rename /var/lib/docker/tmp for background...hronously"
		Sep 06 21:54:05 docker1 dockerd[2194]: time="2017-09-06T21:54:05.421102352+07:00" level=warning msg="overlay: the backing xfs filesystem is formatted without d_ty...
		Sep 06 21:54:05 docker1 dockerd[2194]: time="2017-09-06T21:54:05.541746640+07:00" level=info msg="Graph migration to content-addressability took 0.00 seconds"
		Sep 06 21:54:05 docker1 dockerd[2194]: time="2017-09-06T21:54:05.544930723+07:00" level=info msg="Loading containers: start."
		Sep 06 21:54:06 docker1 dockerd[2194]: time="2017-09-06T21:54:06.931709192+07:00" level=info msg="Default bridge (docker0) is assigned with an IP addres...P address"
		Sep 06 21:54:07 docker1 dockerd[2194]: time="2017-09-06T21:54:07.880341611+07:00" level=info msg="Loading containers: done."
		Sep 06 21:54:07 docker1 dockerd[2194]: time="2017-09-06T21:54:07.934858409+07:00" level=info msg="Docker daemon" commit=8784753 graphdriver(s)=overlay v...17.07.0-ce
		Sep 06 21:54:07 docker1 dockerd[2194]: time="2017-09-06T21:54:07.936237331+07:00" level=info msg="Daemon has completed initialization"
		Sep 06 21:54:07 docker1 dockerd[2194]: time="2017-09-06T21:54:07.983301268+07:00" level=info msg="API listen on /var/run/docker.sock"
		Sep 06 21:54:07 docker1 systemd[1]: Started Docker Application Container Engine.
		Hint: Some lines were ellipsized, use -l to show in full.
		```

- Kiểm tra phiên bản của docker sau khi cài đặt, trong hướng dẫn này là bản 17.07.0-ce
	```sh
	docker version
	```
	- Kết quả như sau: 
		```sh
		Client:
		 Version:      17.07.0-ce
		 API version:  1.31
		 Go version:   go1.8.3
		 Git commit:   8784753
		 Built:        Tue Aug 29 17:42:01 2017
		 OS/Arch:      linux/amd64

		Server:
		 Version:      17.07.0-ce
		 API version:  1.31 (minimum version 1.12)
		 Go version:   go1.8.3
		 Git commit:   8784753
		 Built:        Tue Aug 29 17:43:23 2017
		 OS/Arch:      linux/amd64
		 Experimental: false
		``` 

- Kiểm tra xem docker đã hoạt động hay chưa
	```sh
	docker pull hello-world
	```
	- Kết quả như sau:
		```sh 
		Using default tag: latest
		latest: Pulling from library/hello-world
		b04784fba78d: Pull complete
		Digest: sha256:f3b3b28a45160805bb16542c9531888519430e9e6d6ffc09d72261b0d26ff74f
		Status: Downloaded newer image for hello-world:latest
		```
		
- Thử tạo container đầu tiên
	```sh
	docker run hello-world
	```
	- Kết quả như sau: 
		```sh
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

		Share images, automate workflows, and more with a free Docker ID:
		 https://cloud.docker.com/

		For more examples and ideas, visit:
		 https://docs.docker.com/engine/userguide/
		```

- Kết thúc việc cài đặt, nếu kết quả ổn thì bạn đã có thể bắt đầu tìm hiểu về docker.

