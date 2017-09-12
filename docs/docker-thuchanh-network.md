# Thực hành network

Liệt kê các network đang có của host
```sh
docker network ls
```

Thông tin chi tiết về một network mặc định bridge
```sh
docker network inspect bridge
```

Tạo một bridge network với subnet chỉ định
```sh
docker network create --driver=bridge --subnet=192.168.100.0/24 my-net1
```

Chạy một container với network chỉ định
```sh
docker run --network=my-net1 -d httpd
```

Cách tra cứu cú pháp các command về image
```sh
docker network [command] --help
```