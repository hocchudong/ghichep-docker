# Cách viết Docker Compose file.

____

# Mục lục


- [build](#1)
- [context](#2)
- [dockerfile](#3)
- [arg](#4)
- [cache_from](#5)
- [labels](#6)
- [shm_size](#7)
- [cap_add, cap_drop](#8)
- [command](#9)
- [configs](#10)
- [container_name](#11)
- [deploy](#12)
- [devices](#13)
- [depends_on](#14)
- [dns](#15)
- [dns_search](#16)
- [tmpfs](#17)
- [env_file](#18)
- [environment](#19)
- [expose](#20)
- [external_links](#21)
- [extra_hosts](#22)
- [image](#23)
- [links](#24)
- [logging](#25)
- [network_mode](#26)
- [networks](#27)
- [ipv4_address, ipv6_address](#28)
- [ports](#29)
- [volumes](#30)
- [restart](#31)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>

- Nội dung của bài viết nói về cách tạo nên Docker Compose file để sử dụng khi có nhu cầu tạo ra nhiều Docker Container Applications.

- Nội dung sẽ chỉ nói về cú pháp của Docker Compose file với phiên bản 3 (version 3). Nội dung dưới đây sẽ mô tả qua về cấu trúc của Compose file.

+ Một Compose file được sử dụng theo cú pháp của [YAML](http://yaml.org/) để định nghĩa ra các services, networks và volumes. Mặc định đường dẫn để quy định sử dụng cho Compose file là `./docker-compose.yml`.

Một Compose file có thể có phần mở rộng của file là `.yml` hoặc `.yaml`

+ Một dịch vụ được định nghĩa bao gồm cấu hình được áp dụng cho mỗi container chạy dịch vụ đó, giống như việc sử dụng thông qua các tham số của dòng lệnh `docker container create`. Tương tự, network và volume cũng được sử dụng để quy định tương tự với `docker netwok create` và `docker volume network`.

+ Với `docker container create`, các tùy chọn có thể khai báo trong Dockerfile có thể có là `CMD, `EXPOSE`, `VOLUME` hay `ENV` và được xem như là những mặc định. Tuy nhiên, ta không cần phải khai báo lại chúng trong `docker-compose.yml`

+ Cấu trúc của `compose-file.yml` tuân thủ theo định dạng sau:

        <key>: <option>: <value>

- ### <a name="1">build</a>

    - Khai báo cho tùy chọn này được áp dụng vào trong quá trình build (build time).
    - `build` có thể được khai báo cùng với string là một đường dẫn tới ngữ cảnh build.

            version: '3'
            services:
              webapp:
                build: ./dir

        hoặc với một project, ta có thể khai báo đường dẫn cùng với `context` và các tùy chọn trong `Dockerfile`:

            version: '3'
            services:
              webapp:
                build:
                  context: ./dir
                  dockerfile: Dockerfile-alternate
                  args:
                    buildno: 1

        Nếu ta chỉ định `images` trong `build` thì ta có thể khai báo như sau:

            build: ./dir
            image: webapp:tag

        Kết quả là một image có tên là `webapp` được đánh tag là `tag` sẽ được build ra từ đường dẫn `./dir`


        > **Lưu ý:** Tùy chọn này sẽ bị phớt lờ khi triển khai một stack trong `swarm mode`. Câu lệnh `docker stack` chỉ chấp nhận `pre-built images`.

- ### <a name="2">context</a>

    - `context` được sử dụng để khai báo một đường dẫn bao gồm Dockerfile hoặc một `url tới git repository`.

    - Khi giá trị cung cấp là `relative path` nó sẽ được thông dịch `relative` tại vị trí hiện thời của Compose file. Đường dẫn này cũng là một ngữ cảnh build được gửi đến Docker daemon.

    - Compose builds và tags nó với một tên ngẫu nhiên và sử dụng và sử dụng image này sau đó. Ta có thể khai báo như sau:

            build:
                context: ./dir


- ### <a name="3">dockerfile</a>

    - Để sử dụng cùng với Dockerfile. Docker compose file cần phải được khai báo tương tự như sau:

            build:
                context: .
                dockerfile: Dockerfile-alternate


- ### <a name="4">arg</a>

    - Dùng để thêm các đối số được xem là các `giá trị môi trường` được sử dụng trong quá trình build.
    - Đầu tiên, cần khai báo đối số trong Dockerfile:

            ARG password

            RUN scrip-requiring-password.sh  "$password"

        sau đó, ta cần phải khai báo lại trong `build`. Ta có thể sử dụng thông qua một ánh xạ như sau:

            build:
                context: .
                args:
                    password: PASSWORD

        hoặc

            build:
                context: .
                args:
                    - password=PASSWORD

    - Ta cũng có thể bỏ qua giá trị của biến khi khai báo, trong trường hợp giá trị của nó tại `build time` cũng là giá trị của biến môi trường cung cấp để Compose hoạt động.

            args:
                - password

        > **Lưu ý**: Các giá trị `boolean` như (`true`, `false`, `yes`, `no`, `on` hay `off`) phải được đặt trong `quotes` để đảm bao cho trình dịch có thể hiểu được nó như là một chuỗi.

- ### <a name="5">cache_from</a>

    > **Lưu ý:** Đây là tùy chọn được sử dụng trong version 3.2

    - Một loạt các image được Docker Engine sử dụng cho phân giải cache được mô tả như sau:

            build:
                context: .
                cache_from:
                    - alpine:latest
                    - corp/web_app:3.14

- ### <a name="6">labels</a>
    > **Lưu ý:** Tùy chọn này được sử dụng trong version 3.3

    - Để thêm `metadata` tới kết quả của image sử dụng [`Docker labels`](https://docs.docker.com/engine/userguide/labels-custom-metadata/). Ta có thể sử dụng giống như một mảng hoặc một `dictionary`.

    - Nó được khuyến nghị khi đang sử dụng reverse-DNS notation để ngăn chặn việc labels có thể xung đột với các labels được sử dụng bởi software khác.

            build:
              context: .
              labels:
                com.example.description: "Accounting webapp"
                com.example.department: "Finance"
                com.example.label-with-empty-value: ""

        hoặc

            build:
              context: .
              labels:
                - "com.example.description=Accounting webapp"
                - "com.example.department=Finance"
                - "com.example.label-with-empty-value"

- ### <a name="7">shm_size</a>

    > Đã được thêm vào version 3.5 file format

    - Quy định kích thước của phân vùng `/dev/shm` cho các container được build ra. Việc khai báo nhận một giá trị thực hoặc một chuỗi bytes. Ví dụ, ta có thể khai báo như sau:

            build:
              context: .
              shm_size: '2gb'

        hoặc

            build:
              context: .
              shm_size: 10000000


- ### <a name="8">cap_add, cap_drop</a>

    - Sử dụng để thêm hoặc loại bỏ khả năng của container. Ta có thể xem danh sách các khả năng của container qua [`man 7 capabilities`](https://linux.die.net/man/7/capabilities)

    - Ví dụ khai báo có thể là:

            cap_add:
              - ALL

            cap_drop:
              - NET_ADMIN
              - SYS_ADMIN

        > **Lưu ý:** Tùy chọn này được phớt lờ đi khi triển khai cùng với stack trong swarm mode


- ### <a name="9">command</a>

    - Override default command

    - Cách khai báo có thể được sử dụng như sau:

            command: bundle exec thin -p 3000

        hoặc có thể khai báo trên nhiều dòng như sau:

            command: >
              bash -c "./manage.py migrate && 
               ./manage.py collectstatic --noinput && 
               ./manage.py runserver 0.0.0.0:8000"


- ### <a name="10">configs</a>

    - Sử dụng để cấp phép truy cập cấu hình trên mỗi dịch vụ. Có 2 cách để sử dụng như sau:

        + Cú pháp ngắn (Short syntax)
            - Chỉ khai báo tên cấu hình (config name). Việc cấp quyền cho container sẽ thông qua config name. Ví dụ:

                    version: "3.3"
                        services:
                          redis:
                            image: redis:latest
                            deploy:
                              replicas: 1
                            configs:
                              - my_config
                              - my_other_config
                        configs:
                          my_config:
                            file: ./my_config.txt
                          my_other_config:
                            external: true

                theo ví dụ trên: service `redis` sẽ có 2 config name là `my_config` và `my_other_config`. Nội dung cấu hình của `my_config` được khai báo trong file có tên là `my_config.txt`, còn `my_other_config` được khai báo như một `external resource` - điều này có nghĩa là nó đã được quy định trong Docker. 

        + Cú pháp dài (Long syntax)
            - Cung cấp chi tiết về nội dung các cấu hình cho service
                + `source`: Khai báo tên của config và nó đã tồn tại trong Docker
                + `target`: Đường dẫn tới file sẽ được mount với service. Mặc định nếu đường dẫn không khai báo thì nó sẽ được hiểu là `/<source>`
                + `uid` và `gid`: Không hỗ trợ trên Windows, thể hiện giá trị của UID và GID
                + `mode`: thực hiện gán quyền truy cập cho service.

            - Ví dụ:

                    version: "3.3"
                        services:
                          redis:
                            image: redis:latest
                            deploy:
                              replicas: 1
                            configs:
                              - source: my_config
                                target: /redis_config
                                uid: '103'
                                gid: '103'
                                mode: 0440
                        configs:
                          my_config:
                            file: ./my_config.txt
                          my_other_config:
                            external: true


- ### <a name="11">container_name</a>

    - Khai báo tên `custom container name` thay vì mặc định:

            container_name: my-web-container

        Mặc định trong Docker, tên của mỗi container phải là duy nhất. Vì vậy mà ta không thể scale nếu như sử dụng `custom container name`.

- ### <a name="12">deploy</a>

    - > Chỉ hỗ trợ trong version 3

    - Sử dụng để khai báo cấu hình liên quan đến việc deploy và run service. Nó chỉ ảnh hưởng khi bạn triển khai trong swarm với [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) và bị phớt lờ bởi `docker-compose up` và `docker-compose run`.

    - Ví dụ:

            version: '3'
            services:
              redis:
                image: redis:alpine
                deploy:
                  replicas: 6
                  update_config:
                    parallelism: 2
                    delay: 10s
                  restart_policy:
                    condition: on-failure

- ### <a name="13">devices</a>

    - Liệt kê `device mappings`. Sử dụng cùng format với `--device` flag. Ví dụ:

            devices:
              - "/dev/ttyUSB0:/dev/ttyUSB0"

        > *bị phớt lờ khi ta sử dụng trong swarm*

- ### <a name="14">depends_on</a>

    - Thể hiện sụ phụ thuộc giữa services. Ví dụ:

            version: '3'
                services:
                  web:
                    build: .
                    depends_on:
                      - db
                      - redis
                  redis:
                    image: redis
                  db:
                    image: postgres


- ### <a name="15">dns</a>

    - Sử dụng để khai báo `custom DNS servers`. Có thể khai báo theo giá trị hoặc list.
    - Ví dụ:

            dns: 8.8.8.8

        hoặc 

            dns:
              - 8.8.8.8
              - 9.9.9.9

- ### <a name="16">dns_search</a>

    - Sử dụng để khai báo Custom DNS search domains. Có thể khai báo theo giá trị hoặc list.
    - Ví dụ:

            dns_search: example.com

        hoặc
            dns_search:
              - dc1.example.com
              - dc2.example.com

- ### <a name="17">tmpfs</a>

    - Sử dụng để khai báo `mount a temporary file system` trong container. Có thể khai báo theo giá trị hoặc list.
    - Ví dụ:

            tmpfs: /run

        hoặc

            tmpfs:
              - /run
              - /tmp

- ### <a name="18">env_file</a>

    - Sử dụng để khai báo `environment variables` từ một file nào đó. Có thể khai báo theo giá trị hoặc list.
    - Ví dụ:

            env_file: .env

        hoặc

            env_file:
              - ./common.env
              - ./apps/web.env
              - /opt/secrets.env

- ### <a name="19">environment</a>

    - Sử dụng để khai báo `environment variables`. Các giá trị của biến thuộc dạng boolean cần phải đưa vào trong cặp dấu `''`.
    - Ví dụ:

            environment:
              RACK_ENV: development
              SHOW: 'true'
              SESSION_SECRET:

            environment:
              - RACK_ENV=development
              - SHOW=true
              - SESSION_SECRET

- ### <a name="20">expose</a>

    - Expose ports mà `không cần phải publishing` chúng tới host machine - nếu như chúng chỉ cần để gắn kết các dịch vụ. Ví dụ:

            expose:
             - "3000"
             - "8000"

- ### <a name="21">external_links</a>

    - Link tới một hay nhiều container khác nằm ngoài nội dung của `docker-compose.yml`. Có tác dụng tương tự như `--link` flag. Ví dụ:

            external_links:
             - redis_1
             - project_db_1:mysql
             - project_db_1:postgresql

- ### <a name="22">extra_hosts</a>

    - Sử dụng để thêm `hostname mappings`. Tương tự như `--add-host` flag. Ví dụ:

            extra_hosts:
             - "somehost:162.242.195.82"
             - "otherhost:50.31.209.229"

        kết quả là nội dung trong file `/etc/hosts` của container sẽ có nội dung như sau:

            162.242.195.82  somehost
            50.31.209.229   otherhost

- ### <a name="23">image</a>
    - Khai báo image để chạy container. Có thể khai báo kèm theo repository/tag hoặc một phần `image ID`. Các ví dụ sau đây đều có thể xem là hợp lệ:

            image: redis
            image: ubuntu:14.04
            image: tutum/influxdb
            image: example-registry.com:4000/postgresql
            image: a4bc65fd

- ### <a name="24">links</a>
    - Link container tới một hay nhiều dịch vụ. Ví dụ:

            web:
              links:
               - db
               - db:database
               - redis

- ### <a name="25">logging</a>
    - Cấu hình log cho dịch vụ. Ví dụ:

            logging:
              driver: syslog
              options:
                syslog-address: "tcp://192.168.0.42:123"

        `driver` khai báo tên `logging driver ` dùng cho container của service. Bao gồm `json-file`, `syslog` và `none`.

- ### <a name="26">network_mode</a>
    - Khai báo `network mode`  sử dụng chung các giá trị với `--net` hoặc với hình thức đặc biệt theo form `service:[service name]`. Ví dụ:

            network_mode: "bridge"
            network_mode: "host"
            network_mode: "none"
            network_mode: "service:[service name]"
            network_mode: "container:[container name/id]"

        > *Lưu ý*: `network_mode: "host"` không thể được sử dụng cùng với `links`.

- ### <a name="27">networks</a>
    - Khai báo `network` cho service. Ví dụ:

            services:
              some-service:
                networks:
                 - some-network
                 - other-network

- ### <a name="28">ipv4_address, ipv6_address</a>

    - Sử dụng để thiết lập địa chỉ `static IP` cho container đối với service khi kết nối network.
        > Không hoạt động ổn định trong swarm mode.

            version: '2.1'

            services:
              app:
                image: busybox
                command: ifconfig
                networks:
                  app_net:
                    ipv4_address: 172.16.238.10
                    ipv6_address: 2001:3984:3989::10

            networks:
              app_net:
                driver: bridge
                enable_ipv6: true
                ipam:
                  driver: default
                  config:
                  -
                    subnet: 172.16.238.0/24
                  -
                    subnet: 2001:3984:3989::/64

- ### <a name="29">ports</a>

    - Sử dụng để `expose port`.

        + Short Syntax:

                ports:
                 - "3000"
                 - "3000-3005"
                 - "8000:8000"
                 - "9090-9091:8080-8081"
                 - "49100:22"
                 - "127.0.0.1:8001:8001"
                 - "127.0.0.1:5000-5010:5000-5010"
                 - "6060:6060/udp"

        + Long Syntax:

                ports:
                  - target: 80
                    published: 8080
                    protocol: tcp
                    mode: host
            trong đó:

            | Tham số | Ý nghĩa |
            | ------------- | ------------- |
            | target | Khai báo port bên trong container |
            | published | Khai báo port để expose |
            | protocol | Khai báo port protocol (tcp/ udp) |
            | mode | Dùng `host` để publishing host port trên từng node hoặc `ingress` cho swarm mode port để load balanced |

            > Được sử dụng trong v3.2
            
- ### <a name="30">volumes</a>
    - Sử dụng để `mount host path` hoặc `named volumes` tới service. Ví dụ:

            version: "3.2"
            services:
              web:
                image: nginx:alpine
                volumes:
                  - type: volume
                    source: mydata
                    target: /data
                    volume:
                      nocopy: true
                  - type: bind
                    source: ./static
                    target: /opt/app/static

              db:
                image: postgres:latest
                volumes:
                  - "/var/run/postgres/postgres.sock:/var/run/postgres/postgres.sock"
                  - "dbdata:/var/lib/postgresql/data"

            volumes:
              mydata:
              dbdata:

        theo ví dụ trên, volume có tên là `mydata` sẽ được sử dụng bởi `web` service. 

        + Short syntax

                volumes:
                  # Just specify a path and let the Engine create a volume
                  - /var/lib/mysql

                  # Specify an absolute path mapping
                  - /opt/data:/var/lib/mysql

                  # Path on the host, relative to the Compose file
                  - ./cache:/tmp/cache

                  # User-relative path
                  - ~/configs:/etc/configs/:ro

                  # Named volume
                  - datavolume:/var/lib/mysql

        + Long syntax

                version: "3.2"
                services:
                  web:
                    image: nginx:alpine
                    ports:
                      - "80:80"
                    volumes:
                      - type: volume
                        source: mydata
                        target: /data
                        volume:
                          nocopy: true
                      - type: bind
                        source: ./static
                        target: /opt/app/static

                networks:
                  webnet:

                volumes:
                  mydata:

            trong đó:

            | Tham số | Mô tả |
            | ------------- | ------------- |
            | type | Bao gồm các giá trị `volume`, `bind`, `tmpfs` |
            | source | Khai báo source để thực hiện mount |
            | target | Khai báo đường dẫn trong container - nơi được mounted với volume |
            | read_only | flag quy định mode của volume là chỉ đọc |
            | volume | Dùng để khai báo thêm các cấu hình cho volume. `nocopy` dùng để ngăn việc copy dữ liệu từ container khi volume được tạo|
            
- ### <a name="31">restart</a>
    - Thiết lập chính sách `restart` cho container. `no` được xem là giá trị mặc định. Các giá trị bao gồm được cho là: `no`, `always`, `on-failure` và `unless-stopped`. Ví dụ:

            restart: "no"
            restart: always
            restart: on-failure
            restart: unless-stopped

____

# <a name="content-others">Các nội dung khác</a>
