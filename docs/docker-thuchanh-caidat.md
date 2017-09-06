# Cài đặt docker engine
## Cài bản stable mới nhất
- Các os áp dụng: CentOS 7.3 64bit, Ubuntu 14.04 64bit, Ubuntu 16.04 64bit
- Đăng nhập với quyên root và thực hiện lệnh dưới để cài đặt. Đảm bảo máy có kết nối internet.
	```sh
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


