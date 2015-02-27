### Ghi chép về Dockerfile
- Dockerfile có thể hình dung như một script dùng để build các image trong container.
- Trong `Dockerfile` có các câu lệnh chính sau:
```sh
FROM
RUN
CMD
....còn nữa
```

#### Với lệnh FROM
- Dùng để chỉ ra image được build từ đâu (từ image gốc nào)
```sh
FROM ubuntu

hoặc có thể chỉ rõ tag của image gốc

FROM ubuntu14.04:lastest
```

#### Với lệnh RUN
- Dùng để chạy một lệnh nào đó khi build image, ví dụ về một Dockerfile
```sh
FROM ubuntu
RUN apt-get update
RUN apt-get install curl -y
```


#### Với lệnh CMD
- Lệnh CMD dùng để truyền một lệnh của Linux mỗi khi thực hiện khởi tạo một container từ image (image này được build từ `Dockerfile`)
- Có 3 cách sử dụng lệnh CMD, ví dụ 
```sh 
FROM ubuntu
RUN apt-get update
RUN apt-get install curl -y
CMD ["curl", "ipinfo.io"]
```
hoặc
```sh 
FROM ubuntu
RUN apt-get update
RUN apt-get install wget -y
CMD curl ifconfig.io
```

