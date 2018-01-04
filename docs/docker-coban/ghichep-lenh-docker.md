# 2. Các câu lệnh được dùng phổ biến khi sử dụng Docker

____

# Mục lục


- [2.1 Nhóm lệnh thao tác với container](#docker-container)
- [2.2 Nhóm lệnh điều khiển container](#docker-control)
- [2.3 Nhóm lệnh thao tác với network](#docker-network)
- [2.4 Nhóm lệnh thao tác monitor](#)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="docker-container">2.1 Nhóm lệnh thao tác với container</a>

    - Câu lệnh `docker search`:

        + Chức năng: Tìm kiếm một images từ Docker Hub.

        + Cú pháp:

                docker search [OPTIONS] TERM

            trong đó options bao gồm:

            | Options | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --limit | 25 | Max number of search results |


        + Ví dụ:

                docker search debian

    - Câu lệnh `docker pull`:

        + Chức năng: Pull một image hoặc một repository từ registry.

        + Cú pháp:

                docker pull [OPTIONS] NAME[:TAG|@DIGEST]

            trong đó options bao gồm:

            | Options | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --all-tags , -a |  | Download tất cả tagged images trong repository |
            | --disable-content-trust | true | Bỏ qua việc xác minh image |
            
            - NAME là tên của image

        + Ví dụ: Để pull một image từ Docker Hub. Ta thực hiện sử dụng câu lệnh:

                docker pull debian

            kết quả:

                Using default tag: latest
                latest: Pulling from library/debian
                fdd5d7827f33: Pull complete
                : Pull complete
                Digest: sha256:e7d38b3517548a1c71e41bffe9c8ae6d6d29546ce46bf62159837aad072c90aa
                Status: Downloaded newer image for debian:latest

            Docker images trên bao gồm 2 layer đó là: `fdd5d7827f33` và `a3ed95caeb02`.

    - Câu lệnh `docker create`:

        + Chức năng: Tạo ra một container mới

        + Cú pháp:

                docker create [OPTIONS] IMAGE [COMMAND] [ARG...]

            trong đó các options phổ biến bao gồm:

            | Options | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --attach , -a |  | Attach to STDIN, STDOUT or STDERR |
            | --expose |  | Để lộ ra một port hoặc một dải port - public port |
            | --env , -e |  | Khai báo giá trị biến môi trường. Một vài image sẽ yêu cầu options này khi tạo ra container |
            | --hostname , -h |  | Khai báo container host name |
            | --ip |  | Khai báo địa chỉ IPv4 cho container |
            | --interactive , -i |  | Keep STDIN open even if not attached |
            | --link |  | Khai báo tên container gắn kết với container sẽ tạo |
            | --name |  | Khai báo tên cho container |
            | --publish , -p |  | Publish port(s) của container tới host |
            | --publish-all , -P |  | Publish tất cả exposed ports to ports ngẫu nhiên|
            | --rm |  | Tự động xóa container khi thoát ra |
            | --runtime |  | Khai báo runtime cho container |
            | --volume , -v      |  | Gán một volume tới container |
            | --tty , -t |  | Allocate a pseudo-TTY |
        
        + Ví dụ: Để tạo ra một container từ image có tên là fedora và giao tiếp với cli của container. Sử dụng câu lệnh:

                docker create -t -i fedora bash

            hoặc

                docker create -it fedora bash

            kết quả:

                6d8af538ec541dd581ebc2a24153a28329acb5268abe5ef868c1f1a261221752
            
            đây là ID của container được sử dụng thay cho tên (Có thể sử dụng một vài ký tự đầu của ID thay vì sử dụng toàn bộ)

    - Câu lệnh `docker cp`:

        + Chức năng: Copy file/ folder giữa container và local filesystem.

        + Cú pháp:

                docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
                docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PATH

            trong đó các option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --archive , -a |  | Archive mode (copy all uid/gid information) |
            | --follow-link , -L |  | Always follow symbol link in SRC_PATH |

            nếu ký tự `-` được khai báo, ta có  thể stream một file tar từ STDIN hoặc STOUT.

            Khai báo `compassionate_darwin:/tmp/foo/myfile.txt` và `compassionate_darwin:tmp/foo/myfile.txt` được xem là 2 khai báo giống nhau. Do `docker cp` giả định đường dẫn tương đối là `/` (root)
    
    - Câu lệnh `docker volume`:

        + Chức năng: Cung cấp các lệnh con để quản lý dữ liệu đối với containers.

        + Các câu lệnh con bao gồm:

            | Command | Mô tả |
            | ------------- | ------------- |
            | docker volume create | Tạo một volume |
            | docker volume inspect | Hiển thị thông tin về một hay nhiều volumes |
            | docker volume ls | Liệt kê volumes |
            | docker volume prune | Loại bỏ volumes không sử dụng |
            | docker volume rm | Loại bỏ một hay nhiều volumes |
            
        + Ví dụ: Để tạo một volume, ta sử dụng câu lệnh `docker volume create` với cú pháp:

                docker volume create [OPTIONS] [VOLUME]

            trong đó các option bao gồm:

            | Options | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --driver , -d | local | Khai báo tên volume driver |
            | --label |  | Set metadata for a volume |
            | --name |  | Khai báo tên volume |
            | --opt , -o |  | Set driver specific options |

            chẳng hạn `docker volume create hello`.

        + Một ví dụ khác là tạo một volume tpe nfs mout đường dẫn `/path/to/dir` với chế độ `rw` từ host `192.168.1.1`. Ta sử dụng thêm tùy chọn `--opt` như sau:

                docker volume create --driver local \
                --opt type=nfs \
                --opt o=addr=192.168.1.1,rw \
                --opt device=:/path/to/dir \
                hello

    - Câu lệnh `docker build`:

        + Chức năng: Build một image từ một Dockerfile.

        + Cú pháp:

                docker build [OPTIONS] PATH | URL | -

            trong đó options phổ biến bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --file , -f |  | Khai báo tên của Dockerfile. Mặc định là ‘PATH/Dockerfile’ |
            | --rm | true | Loại bỏ các container trung gian sau khi build thành công |
            
    - Câu lệnh `docker push`:

        + Chức năng: Push một image hoặc một repository tới registry.

        + Cú pháp:

                docker push [OPTIONS] NAME[:TAG]

            trong đó option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --disable-content-trust | true | Skip image signing |
            
        + Ví dụ: Muốn push một image, ta cần phải commit image, sau đó tạo ra tag image trước khi push.

                docker commit c16378f943fe rhel-httpd

                docker tag rhel-httpd registry-host:5000/myadmin/rhel-httpd

                docker push registry-host:5000/myadmin/rhel-httpd

    - Câu lệnh `docker rename`:

        + Chức năng: Thay đổi tên của một container.

        + Cú pháp:

                docker rename CONTAINER NEW_NAME

        + Ví dụ:

                docker rename c16378f943fe mysql

    - Câu lệnh `docker save`:

        + Chức năng: Lưu một hoặc nhiều image tới một file nén tar (mặc định streamed từ STDOUT)

        + Cú pháp:

                docker save [OPTIONS] IMAGE [IMAGE...]

            trong đó option có thể là:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --output , -o |  | Ghi dữ liệu ra một file với tên khai báo, thay thế cho STDOUT |

        + Ví dụ:

                docker save busybox > busybox.tar

            hoặc

                docker save --output busybox.tar busybox
            
- ### <a name="docker-control">2.2 Nhóm lệnh điều khiển container</a>

    - Câu lệnh `docker run`:

        + Chức năng: Tạo mới một container và tự động khởi chạy nó khi tạo xong. Câu lệnh này có vai trò tương tự như câu lệnh `docker create` nhưng `docker create` còn cho phép cấu hình hình thêm các yêu cầu còn thiếu sau khi tạo ra container để có thể hoạt động đúng mục đích.

        + Cú pháp:

                docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

            trong đó các option phổ biến bao gồm:

            | Options | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --attach , -a |  | Attach to STDIN, STDOUT or STDERR |
            | --expose |  | Để lộ ra một port hoặc một dải port - public port |
            | --env , -e |  | Khai báo giá trị biến môi trường. Một vài image sẽ yêu cầu options này khi tạo ra container |
            | --detach , -d |  | Chạy container trong background và print container ID |
            | --hostname , -h |  | Khai báo container host name |
            | --ip |  | Khai báo địa chỉ IPv4 cho container |
            | --interactive , -i |  | Keep STDIN open even if not attached |
            | --link |  | Khai báo tên container gắn kết với container sẽ tạo |
            | --name |  | Khai báo tên cho container |
            | --publish , -p |  | Publish port(s) của container tới host |
            | --publish-all , -P |  | Publish tất cả exposed ports to ports ngẫu nhiên|
            | --rm |  | Tự động xóa container khi thoát ra |
            | --runtime |  | Khai báo runtime cho container |
            | --volume , -v      |  | Gán một volume tới container |
            | --tty , -t |  | Allocate a pseudo-TTY |

        + Ví dụ: Để chạy một container của image debian có tên là test. Ta thực hiện sử dụng câu lệnh:

                docker run --name test -itd debian

    - Câu lệnh `docker start`:

        + Chức năng: Khởi chạy một container khi nó đang ở trạng thái `created`. Hoặc dừng nhiều container khi các container đang ở trạng thái `running`

        + Cú pháp:

                docker start [OPTIONS] CONTAINER [CONTAINER...]

            trong đó các option phổ biến hay dùng là:

            | Option | Mặc định |  |
            | ------------- | ------------- | ------------- |
            | --attach , -a |  | Attach STDOUT/STDERR and forward signals |
            | --interactive , -i |  | Attach container’s STDIN |

        + Ví dụ: Để khởi chạy một container có tên là docker-mysql. Ta sử dụng câu lệnh:

                docker start docker-mysql

    - Câu lệnh `docker restart`:

        + Chức năng: Restart một hoặc nhiều container khi container đang ở trạng thái `running`

        + Cú pháp:

                docker restart [OPTIONS] CONTAINER [CONTAINER...]

            trong đó option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --time , -t| 10 | Khai báo thời gian chờ để thực hiện stop container trước khi kill container |

        + Ví dụ: Để restart docker có tên là docker-mysql. Ta sử dụng câu lệnh:

                docker restart docker-mysql

    - Câu lệnh `docker stop`:

        + Chức năng:  Dừng một hoặc nhiều container đang chạy

        + Cú pháp:

                docker stop [OPTIONS] CONTAINER [CONTAINER...]

            trong đó option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --time , -t| 10 | Khai báo thời gian chờ để thực hiện stop container trước khi kill container |
            
        + Ví dụ:

                docker stop docker-mysql

    - Câu lệnh `docker exec`:

        + Chức năng: Chạy một command bên trong container đang ở trạng thái `running`.

        + Cú pháp:

                docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

            trong đó các option phổ biến bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --detach , -d |  | Detached mode: run command in the background |
            | --env , -e |  | Set environment variables |
            | --interactive , -i     |  | Keep STDIN open even if not attached |
            | --tty , -t |  | Allocate a pseudo-TTY |

        + Ví dụ:

                docker exec -it debian bash

    - Câu lệnh `docker rm`:

        + Chức năng: Loại bỏ một hoặc nhiều container.

        + Cú pháp:

                docker rm [OPTIONS] CONTAINER [CONTAINER...]

            trong đó các option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --force , -f |  | Được sử dụng để loại bỏ container khi nó đang ở trạng thái `running` |
            | --link , -l |  | Loại bỏ container liên kết được khai báo |
            | --volumes , -v     |  | Loại bỏ volume liên kết với container |

        + Ví dụ:

                docker rm -f docker-mysql

    - Câu lệnh `docker rmi`:

        + Chức năng: Loại bỏ một image. Khi loại bỏ một image, thì các container đang sử dụng image bị loại bỏ sẽ không thể hoạt động.

        + Cú pháp:

                docker rmi [OPTIONS] IMAGE [IMAGE...]

            trong đó các option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --force , -f |  | Được sử dụng để loại bỏ image khi image đang được dùng cho một hay nhiều container |
            | --no-prune |  | Do not delete untagged parents |

        + Ví dụ:

                docker rmi debian

    - Câu lệnh `docker attach`:

        + Chức năng: Attach local standard input, output, and error streams to a running container

        + Cú pháp:

                docker attach [OPTIONS] CONTAINER

            trong đó các option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --detach-keys |  | Override the key sequence for detaching a container |
            | --no-stdin     |  | Do not attach STDIN |
            | --sig-proxy | true | Proxy all received signals to the process |

        + Ví dụ:

                docker attach debian

- ### <a name="docker-network">2.3 Nhóm lệnh thao tác với network</a>

    - Các lệnh thao tác với network bao gồm:

        | Command | Mô tả |
        | ------------- | ------------- |
        | docker network connect | Kết nối container tới một network |
        | docker network create | Tạo ra một network mới |
        | docker network disconnect | Ngắt kết nối container từ một network |
        | docker network inspect | Hiển thị thông tin chi tiết về một hay nhiều networks |
        | docker network ls | Liệt kê các network |
        | docker network prune | Loại bỏ các network không được sử dụng |
        | docker network rm | Loại bỏ một hoặc nhiều các network |

    - Để biết chi tiết về các lệnh, ta sử dụng cú pháp

            command --help

        ví dụ:

            docker network create --help
        
- ### <a name="">2.4 Nhóm lệnh thao tác monitor</a>

    - Câu lệnh `docker stats`:

        + Chức năng: Hiển thị một livestream thống kê về tài nguyên sử dụng của container(s).

        + Cú pháp:

                docker stats [OPTIONS] [CONTAINER...]

            trong đó các option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --all , -a |  | Hiển thị thống kê cho tất cả containers đang chạy |
            | --no-stream |  | Disable streaming stats and only pull the first result |

        + Ví dụ:

                docker stats --all

    - Câu lệnh `docker ps`:

        + Chức năng: Liệt kê các containers

        + Cú pháp:

                docker ps [OPTIONS]

            trong đó các option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --all , -a |  | Hiển thị thống kê cho tất cả containers đang chạy |
            | --quiet , -q |  | Only display numeric IDs |
            | --size , -s |  | Display total file sizes |
        
        + Ví dụ:

                docker ps --all

    - Câu lệnh `docker inspect`:

        + Chức năng: Hiển thị thông tin của Docker objects

        + Cú pháp:

                docker inspect [OPTIONS] NAME|ID [NAME|ID...]

            trong đó các option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --format , -f |  | Format the output using the given Go template |
            | --size , -s |  | Display total file sizes if the type is container |
            | --type |  | Return JSON for specified type |

        + Ví dụ:

                docker inspect debian

    - Câu lệnh `docker images`:

        + Chức năng: Liệt kê các image trên local

        + Cú pháp:

                docker images [OPTIONS] [REPOSITORY[:TAG]]

            trong đó các option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --all , -a |  | Hiển thị tất cả các image |
            | --digests |  | Show digests |
            | --quiet , -q   |  | Only show numeric IDs |

    - Câu lệnh `docker network ls`:

        + Chức năng: Liệt kê danh sách các network interfaces

        + Cú pháp:

                docker network ls [OPTIONS]

            trong đó các option bao gồm:

            | Option | Mặc định | Mô tả |
            | ------------- | ------------- | ------------- |
            | --quiet , -q   |  | Only show numeric IDs |
____

# <a name="content-others">Các nội dung khác</a>

1. Tham khảo: [Docker - Commandline Reference](https://docs.docker.com/engine/reference/commandline)