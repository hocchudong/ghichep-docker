# LAB1: Cài đặt docker

tham khảo tại [link](https://github.com/congto/ghichep-docker/blob/master/docs/docker-thuchanh-caidat.md)

# LAB2: Kiểm tra hoạt động của docker

tham khảo tại [link](https://github.com/congto/ghichep-docker/blob/master/docs/docker-thuchanh-caidat.md)

# LAB3: Tạo một container

Sử dụng lệnh `docker run` để tạo một docker từ image có sẵn. Cú pháp lệnh:
```sh
$ docker run [options] [image] [command] [args]
```

Trong đó, nếu có nhiều image thì chỉ định image cho docker với repository:tag. Nếu không chỉ định thì mặc định sẽ lấy tag là `latest`

Ví dụ:
```sh
docker run ubuntu:14.04 ps aux
```

Tạo container, đồng thời sử dụng terminal của container thì bổ sung tham số:
- `-i` tham số chỉ định docker kết nối tới STDIN trên container
- `-t` tham số chỉ định tạo ra một giả lập terminal.

Ví dụ:
```sh
docker run -i -t ubuntu /bin/bas
```

Có một tham số `-d` để chỉ định cho container sẽ chạy nền hoặc như một daemon. Ví dụ:
```sh
docker run -d ubuntu ping 127.0.0.1 -c 50
```

Tạo container ở trên sẽ sinh ra tên một cách ngẫu nhiên, sử dụng tham số `--name` để đặt tên cho container. Ví dụ
```sh
docker run -it --name ubuntu_example ubuntu /bin/bash
```

# LAB4: Kiểm tra thông tin container

Một container được tạo ra sẽ có rất nhiều thông tin đi kèm. Kiểm tra thông tin ngắn gọn thì sử dụng lệnh:
```sh
docker ps -a
```

Lệnh trên sẽ cho bạn biết thông tin về tất cả các container đang chạy hoặc đã dừng: tên và id của container, image mà container sử dụng, trạng thái, thời gian chạy.

Kiểm tra thông tin chi tiết của container thì ta sử dụng lệnh:
```sh
docker inspect [containerID/containerName]
```

Bạn có thể thay ID hoặc tên của container vào lệnh trên. Rất nhiều thông tin được hiển thị ra dưới định dạng JSON

Theo dõi các thông tin log mà container xuất ra bằng lệnh:
```sh
docker logs [containerID]
```

# LAB5: Chạy một container với port NAT chỉ định và gắn Volume

Trong trường hợp muốn chỉ định một port từ máy host vào port dịch vụ mà ứng dụng trong container cung cấp dịch vụ thì cần sử dụng tham số `-p`. Ví dụ:
```sh
docker run --name apache_test1 -p 8080:80 -p 443:443 -d eboraas/apache
```

Nếu bạn có một thư mục chứa code hoặc tham số cấu hình trên máy host, muốn ứng dụng trong container sử dụng được thì sử dụng tham số `-v` để chỉ dẫn cho container biết. Ví dụ:
```sh
mkdir -p website && cd website

docker run --name apache_test2 -p 8080:80 -p 443:443 -v $(pwd):/var/www/  -d eboraas/apache
```

Kiểm tra việc chỉnh sửa code trên host có được thay đổi ngay trong docker không bằng cách sau:
```sh
mkdir html

echo "test website at host" >> index.html

curl localhost:8180
```

# LAB6: Liên kết giữa các container

Bạn có nhiều ứng dụng đang chạy trên các container riêng lẻ, ví dụ: web server, database thì làm cách nào để chúng liên kết lại với nhau. Chúng ta sử dụng tham số `--link`.

Bây giờ tôi tạo một Drupal app (apache, php, mysql, drupal) bằng cách sau:
```sh
mkdir -p drupal-link-example && cd drupal-link-example

docker pull drupal:8.0.6-apache
docker pull mysql:5.5

// Start a container for mysql
docker run --name mysql_example \
           -e MYSQL_ROOT_PASSWORD=root \
           -e MYSQL_DATABASE=drupal \
           -e MYSQL_USER=drupal \
           -e MYSQL_PASSWORD=drupal \
           -d mysql:5.5

// Start a Drupal container and link it with mysql
// Usage: --link [name or id]:alias
docker run -d --name drupal_example \
           -p 8280:80 \
           --link mysql_example:mysql \
           drupal:8.0.6-apache

// Open http://localhost:8280 to continue with the installation
// On the db host use: mysql

// There is a proper linking
docker inspect -f "{{ .HostConfig.Links }}" drupal_example
```

# LAB7: export/save/load container

```sh
mkdir -p ~/Docker-presentation

docker pull nimmis/alpine-apache
docker run -d --name apache_example \
           nimmis/alpine-apache

// Create a file inside the container.
// See https://github.com/nimmis/docker-alpine-apache for details.
docker exec -ti apache_example \
            /bin/sh -c 'mkdir /test && echo "This is it." >> /test/test.txt'

// Test it. You should see message: "This is it."
docker exec apache_example cat /test/test.txt

// Commit the change.
docker commit apache_export_example myapache:latest

// Create a new container with the new image.
docker run -d --name myapache_example myapache

// You should see the new folder/file inside the myapache_example container.
docker exec myapache_example cat /test/test.txt

// Export the container as image
cd ~/Docker-presentation
docker export myapache_example > myapache_example.tar

// Import a new image from the exported files
cd ~/Docker-presentation
docker import myapache_example.tar myapache:new

// Save a new image as tar
docker save -o ~/Docker-presentation/myapache_image.tar myapache:new

// Load an image from tar file
docker load < myapache_image.tar
```

# LAB8: upload image lên repository

```sh
mkdir -p ~/upload && cd ~/upload
git clone git@github.com:theodorosploumis/docker-presentation.git
cd docker-presentation

docker pull nimmis/alpine-apache
docker build -t tplcom/docker-presentation .

// Test it
docker run -itd --name docker_presentation \
           -p 8480:80 \
           tplcom/docker-presentation

// Open http://localhost:8480, you should see this presentation

// Push it on the hub.docker.com
docker push tplcom/docker-presentation
```
