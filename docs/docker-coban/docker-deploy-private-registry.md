# 1. Thực hành triển khai Private Docker Registry

____

# Mục lục


- [1.1 Giới thiệu về Private Docker Registry](#about)
- [1.2 Cài đặt và cấu hình Docker Registry](#deploy)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- ### <a name="about">1.1 Giới thiệu về Private Docker Registry</a>

    + Private Docker Registry là một Docker Registry được triển khai riêng biệt so với Docker Host và được triển khai trên chính server của bạn.

    + Cho phép xử lý các thao tác với Docker image một cách nhanh chóng với pull, push. Và không cần thiết đến internet nếu như Registry được cài đặt trong mạng LAN, cho phép phân phối các image một cách nhanh chóng.

    + Với Private Docker Registry, ta có thể:

        - Toàn quyền quyển soát được vị trí lưu trữ image.
        - Tích hợp vào quy trình phát triển các sản phẩm.


- ### <a name="deploy">1.2 Cài đặt và cấu hình Docker Registry</a>

    - Yêu cầu trước khi thực hiện cài đặt như sau:

        | STT | Yêu cầu |
        | ------------- | ------------- |
        | 1 | Máy thực hiện cấu hình đã được cài đặt Docker Engine. |
        | 2 | Hệ điều hành sử dụng: CentOS 7 |
    
    - Đầu tiên, ta cài đặt công cụ `htpasswd` của `http-tools` nhắm nâng cao tính bảo mật:

            yum install -y httpd-tools

    - Tiếp theo, cài đặt và cấu hình Private Docker Registry:

        - Hiện tại, Private Registry được Docker công bố như một mã nguồn mở tồn tại dưới dạng là một image có tên là `registry`.

        - Cách đơn giản nhất để sử dụng Private Docker Registry đó là tạo ra một container từ image `registry` với câu lệnh sau:

                docker run -d \
                --publish 5000:5000 \
                --restart=always \
                --name= registry \
                registry:2

            ngay bây giờ registry đã có thể được sử dụng thông qua port 5000.

        - Để thực hiện pull image tới Private Registry, ta có thể thực hiện tương tự như sau:

                docker pull ubuntu:16.04

                docker tag ubuntu:16.04 localhost:5000/ubuntu

        - Lúc này, một image mới được tạo ra có `REPOSITORY` là `localhost:5000/ubuntu`. Để thực hiện push image tới Private Registry, ta sử dụng câu lệnh:

                docker push localhost:5000/ubuntu

        - Để kiểm tra kết quả, ta thực hiện xóa các image đã có để kiểm tra bằng việc sử dụng câu lệnh:

                docker rmi ubuntu:16.04
                docker rmi localhost:5000/ubuntu

            tiếp theo pull image `localhost:5000/ubuntu` về sử dụng câu lệnh:

                docker pull localhost:5000/ubuntu

        - Lưu ý: Khi thực hiện các thao tác giữa image và private registry. Ta cần phải thêm server của image đó đằng trước. Ví dụ:

                localhost:5000/ubuntu

            trong đó

            | Mô tả | Ý nghĩa |
            | ------------- | ------------- |
            | localhost:5000 | Khai báo server và port của registry |
            | ubuntu | Tên image |

            vì mặc định, Docker Engine sử dụng Cloud Registry là `Docker Hub`.

        Việc cấu hình như trên đã đáp ứng đủ để cung cấp một Private Docker Registry. Tuy nhiên, ta nên thực hiện cài đặt và cấu hình Private Docker Registry theo cách dưới đây.

    - Tạo thư mục riêng để quản lý registry:

            mkdir ~/docker-registry && cd $_
            mkdir data

        trong đó:

        | Thư mục | Chức năng |
        | ------------- | ------------- |
        | docker-registry | Dành riêng cho container cung cấp chức năng Registry để lưu toàn bộ dữ liệu vào. |
        | data | Có chức năng mout tới container |

    - Tiếp theo, ta thực cấu hình container NGINX để có thể sử dụng tính năng `Virtual Server` và các tính năng khác. Container NGINX sẽ liên kết với container registry.

        + Đầu tiên, cần tạo một file cấu hình cho container NGINX bằng cách sử dụng câu lệnh:

                mkdir ~/docker-registry/nginx
                vi ~/docker-registry/nginx/registry.conf

            sau đó thêm nội dung cấu hình NGINX như sau vào file và lưu lại:

                upstream docker-registry {
                  server registry:5000;
                }

                server {
                  listen 443;
                  server_name myhub.docker.io;

                  # SSL
                  ssl on;
                  ssl_certificate /etc/nginx/conf.d/domain.crt;
                  ssl_certificate_key /etc/nginx/conf.d/domain.key;

                  # disable any limits to avoid HTTP 413 for large image uploads
                  client_max_body_size 0;

                  # required to avoid HTTP 411: see Issue #1486 (https://github.com/docker/docker/issues/1486)
                  chunked_transfer_encoding on;

                  location /v2/ {
                    # Do not allow connections from docker 1.5 and earlier
                    # docker pre-1.6.0 did not properly set the user agent on ping, catch "Go *" user agents
                    if ($http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$" ) {
                      return 404;
                    }

                    # To add basic authentication to v2 use auth_basic setting plus add_header
                    auth_basic "registry.localhost";
                    auth_basic_user_file /etc/nginx/conf.d/registry.password;
                    add_header 'Docker-Distribution-Api-Version' 'registry/2.0' always;

                    proxy_pass                          http://docker-registry;
                    proxy_set_header  Host              $http_host;   # required for docker client's sake
                    proxy_set_header  X-Real-IP         $remote_addr; # pass on real client's IP
                    proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
                    proxy_set_header  X-Forwarded-Proto $scheme;
                    proxy_read_timeout                  900;
                  }
                }
        
            file cấu hình trên có tác dụng tạo ra một `Virtual Server` có tên là `myhub.docker.io` lắng nghe trên port 443 và mọi request tới port này sẽ được điều hướng tới container registry trên cổng 5000. Và được cấu hình xác thực người dùng mỗi khi truy cập tới virtual server.

        - Tiếp theo, ta thực hiện cấu hình xác thực người dùng đối với NGINX như sau:

                cd ~/docker-registry/nginx
                htpasswd -c registry.password USERNAME

            trong đó:

            | Câu lệnh | Ý nghĩa |
            | ------------- | ------------- |
            | htpasswd -c registry.password USERNAME | Tạo ra một file tên là `registry.password` xác thực cho người dùng là `USERNAME`|

            nếu muốn có nhiều người dùng hơn thì chỉ cần chạy thêm câu lệnh tương tự như sau:

                htpasswd registry.password USERNAME

            USERNAME và PASSWORD nhập vào sẽ được sử dụng để xác thực khi ta login đến Private Registry qua câu lệnh `docker login ...`.

        - Thực hiện cấu hình SSL cho NGINX, lần lượt sử dụng các câu lệnh sau:

                cd ~/docker-registry/nginx

            sinh ra root key mới:

                openssl genrsa -out devdockerCA.key 2048

            sinh ra root certificate:

                openssl req -x509 \
                -new -nodes -key devdockerCA.key \
                -days 10000 \
                -out devdockerCA.crt

            sau đó là tạo key cho server:

                openssl genrsa -out domain.key 2048

            và ta tạo ra domain key với câu lệnh:

                openssl req \
                -new -key domain.key \
                -out dev-docker-registry.com.csr

            kết quả của câu lệnh sẽ yêu cầu nhập vào các thông tin. Lưu ý: `Common Name` hãy chắc chắn rằng sẽ nhập là tên domain hoặc IP của server. Cuối cùng, ta sử dụng câu lệnh sau để kết thúc bước cấu hình này:

                openssl x509 -req \
                -in dev-docker-registry.com.csr \
                -CA devdockerCA.crt \
                -CAkey devdockerCA.key \
                -CAcreateserial \
                -out domain.crt \
                -days 10000

    - Tạo các container để cung cấp Private Registry như sau:

            mv ~/docker-registry /docker-registry

        - Tạo container registry sử dụng câu lệnh:

                docker run -d \
                --restart=always \
                --name registry \
                --publish 127.0.0.1:5000:5000 \
                --mount type=bind,source=/docker-registry/data,target=/data \
                --restart=always \
                --env REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/data \
                --privileged \
                registry:2

        - Tạo container NGINX sử dụng câu lệnh sau:

                docker run -d \
                --name nginx \
                --publish 443:443 \
                --link registry \
                --mount type=bind,source=/docker-registry/nginx,target=/etc/nginx/conf.d,readonly \
                nginx

        - Cuối cùng, ta thực hiện trỏ host tới container. Việc thực hiện tại máy thật cài đặt Docker để kiểm tra:

                echo "127.0.0.1   myhub.docker.io" >> /etc/hosts

            như vậy, ta đã thực hiện cấu hình xong một Registry Docker đơn giản.

        - Kiểm tra kết quả cấu hình sử dụng các câu lệnh sau:

                docker pull centos
                docker tag centos myhub.docker.io/centos:my-os

                docker login myhub.docker.io
                docker push myhub.docker.io/centos:my-os

        - Tóm lại, việc cài đặt có thể sử dụng scripts sau đây:

                curl https://raw.githubusercontent.com/BoTranVan/ghichep-docker/\
                master/scripts/install-private-registry.sh \
                -o ipr.sh
                chmod a+x ipr.sh
                
                curl https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/scripts/gen-cer\
                -o gen-cer
                chmod a+x gen-cer
                
                ./ipr.sh

____

# <a name="content-others">Các nội dung khác</a>
