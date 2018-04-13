# 10. Các lệnh thường được sử dụng trong Docker Swarm.

____

# Mục lục

Nội dung của bài viết này là sẽ nói về cách sử dụng các câu lệnh thường xuyên trong Docker Swarm. Cùng với một vài ví dụ về cách sử dụng câu lệnh.

- [10.1 Câu lệnh docker swarm](#docker-swarm)
    - [10.1.1 Câu lệnh docker swarm init](#docker-swarm-init)
    - [10.1.2 Câu lệnh docker swarm join](#docker-swarm-join)
    - [10.1.3 Câu lệnh docker swarm join-token](#docker-swarm-join-token)
    - [10.1.4 Câu lệnh docker swarm leave](#docker-swarm-leave)
    - [10.1.5 Câu lệnh docker swarm update](#docker-swarm-update)
- [10.2 Câu lệnh docker service](#docker-service)
    - [10.2.1 Câu lệnh docker service create](#docker-service-create)
    - [10.2.2 Câu lệnh docker service inspect](#docker-service-inspect)
    - [10.2.3 Câu lệnh docker service logs](#docker-service-logs)
    - [10.2.4 Câu lệnh docker service ls](#docker-service-ls)
    - [10.2.5 Câu lệnh docker service ps](#docker-service-ps)
    - [10.2.6 Câu lệnh docker service rm](#docker-service-rm)
    - [10.2.7 Câu lệnh docker service rollback](#docker-service-rollback)
    - [10.2.8 Câu lệnh docker service scale](#docker-service-scale)
    - [10.2.9 Câu lệnh docker service update](#docker-service-update)
- [Các nội dung khác](#content-others)

____

# <a name="content">Nội dung</a>


- ### <a name="docker-swarm-init">10.1 Câu lệnh docker swarm</a>
    - Đây được xem là parent command bao gồm các câu lệnh dùng để thao tác với Swarm Mode.
        - [10.1.1 Câu lệnh docker swarm init](#docker-swarm-init)
        - [10.1.2 Câu lệnh docker swarm join](#docker-swarm-join)
        - [10.1.3 Câu lệnh docker swarm join-token](#docker-swarm-join-token)
        - [10.1.4 Câu lệnh docker swarm leave](#docker-swarm-leave)
        - [10.1.5 Câu lệnh docker swarm update](#docker-swarm-update)

- ### <a name="docker-swarm-init">10.1.1 Câu lệnh docker swarm init</a>
    - Dùng để khởi tạo swarm.
    - Cú pháp:

            docker swarm init [OPTIONS]

        trong đó `OPTIONS` được cho như sau:

        | Name, shorthand | Default | Mô tả |
        | ------------- | ------------- | ------------- |
        | --advertise-addr | | Khai báo `ddvertised address`. Có thể là IP, Interface kèm theo PORT |
        | --availability | active | Quy định tình trạng của node. Bao gồm `active`, `pause` và `drain` |
        | --data-path-addr | | Address or interface to use for data path traffic (format: <ip\|interface>) |
        | --dispatcher-heartbeat | 5s | Dispatcher heartbeat period (ns\|us\|ms\|s\|m\|h) |
        | --force-new-cluster |  | Force create a new cluster from current state |
        | --listen-addr | 0.0.0.0:2377 | Listen address (format: <ip\|interface>[:port]) |
        | --task-history-limit | 5 | Task history retention limit |

    - Ví dụ:

            docker swarm init --advertise-addr 192.168.99.121

        dùng để khởi tạo swarm mode. Khi chạy, ta sẽ nhận được hai `random keys` dùng để join `worker node` và `manager node`.

- ### <a name="docker-swarm-join">10.1.2 Câu lệnh docker swarm join</a>
    - Sử dụng để join một node tới swarm đã khởi tạo với vai trò có thể là `worker node` hoặc `manager node`.
    - Cú pháp:

            docker swarm join [OPTIONS] HOST:PORT

        trong đó các option có thể gồm:

        | Name, shorthand | Default | Mô tả |
        | ------------- | ------------- | ------------- |
        | --advertise-addr   || Advertised address (format: <ip\|interface>[:port]) |
        | --availability | active | Quy định tình trạng của node. Bao gồm `active`, `pause` và `drain` |
        | --data-path-addr | | Address or interface to use for data path traffic (format: <ip\|interface>) |
        | --listen-addr | 0.0.0.0:2377 | Listen address (format: <ip\|interface>[:port]) |
        | --token | | Token for entry into the swarm. Đây là giá trị khi ta chạy câu lệnh `docker swarm init` hoặc `docker swarm join-token` để có thể nhận được |
        
    - Ví dụ:

            docker swarm join --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-1awxwuwd3z9j1z3puu7rcgdbx 192.168.99.121:2377

- ### <a name="docker-swarm-join-token">10.1.3 Câu lệnh docker swarm join-token</a>
    - Sử dụng để quản lý `join tokens`.
    - Cú pháp:

            docker swarm join-token [OPTIONS] (worker|manager)

        trong đó các OPTION có thể bao gồm là:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --quiet , -q | | Chỉ hiển thị token |
        | --rotate | Rotate join token |

    - Ví dụ: Để hiển thị token sử dụng để join `manager node` ta sử dụng câu lệnh sau:

            docker swarm join-token manager

- ### <a name="docker-swarm-leave">10.1.4 Câu lệnh docker swarm leave</a>
    - Sử dụng để ngừng chạy trong swarm mode.
    - Cú pháp:

            docker swarm leave [OPTIONS]

        trong đó OPTIONS có thể là:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --force , -f | | Buộc node rời khỏi swarm và phớt lờ các cảnh báo |
        
- ### <a name="docker-swarm-update">10.1.5 Câu lệnh docker swarm update</a>
    - Sử dụng để cập nhật các thông tin trong swarm mode.
    - Cú pháp:

            docker swarm update [OPTIONS]

        trong đó OPTIONS có thể bao gồm như sau:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --force , -f | | Buộc node rời khỏi swarm và phớt lờ các cảnh báo |
        | --dispatcher-heartbeat | 5s | Dispatcher heartbeat period (ns\|us\|ms\|s\|m\|h) |
        | --task-history-limit | 5 | Task history retention limit |

- ### <a name="docker-service">10.2 Câu lệnh docker service</a>
    - Được xem là parent-command bao gồm các câu lệnh thao tác với service trong Swarm Mode.
    - Các câu lệnh bao gồm:

- ### <a name="docker-service-create">10.2.1 Câu lệnh docker service create</a>
    - Sử dụng để tạo services
    - Cú pháp:

            docker service create [OPTIONS] IMAGE [COMMAND] [ARG...]

        trong đó OPTIONS có thể bao gồm như sau:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --constraint   |  | Quy định các ràng buộc đối với service |
        | --container-label |  | Quy định container's label |
        | --detach , -d |  | Exit immediately instead of waiting for the service to converge |
        | --dns |  | Quy định về custom DNS servers |
        | --dns-option |  | Quy định về DNS options |
        | --dns-search |  | Quy định về custom DNS domains |
        | --endpoint-mode | vip | Endpoint mode (vip hoặc dnsrr) |
        | --env , -e |  | Quy định về `environment variables` |
        | --env-file |  | Lấy `environment variables` từ một file |
        | --generic-resource |  | Đưa ra các resource bởi người dùng |
        | --group |  | Quy định một hay nhiều group bổ sung cho container |
        | --health-cmd |  | Command to run to check health |
        | --health-interval |  | Time between running the check (ms|s|m|h) |
        | --host |  | Quy định một hoặc nhiều custom host-IP mappings |
        | --hostname |  | Quy định hostname của container |
        | --isolation |  | Service container isolation mode |
        | --label , -l |  | Service labels |
        | --limit-cpu |  | Limit CPUs |
        | --limit-memory |  | Limit Memory |
        | --mode | replicated | Service mode (replicated hoặc global) |
        | --mount |  | Attach a filesystem mount to the service |
        | --name |  | Service name |
        | --network |  | Network attachments |
        | --publish , -p |  | Publish a port as a node port |
        | --read-only |  | Mount the container’s root filesystem as read only |
        | --replicas |  | Quy định số lượng tasks |
        | --reserve-cpu |  | Reserve CPUs |
        | --reserve-memory |  | Reserve Memory |
        | --restart-condition | any | Restart khi gặp phải điều kiện “none”\|”on-failure”\|”any” |
        | --restart-delay | 5s | Delay between restart attempts (ns\|us\|ms\|s\|m\|h) |
        | --restart-max-attempts |  | Maximum number of restarts before giving up |
        | --rollback-delay | 0s | Delay between task rollbacks (ns\|us\|ms\|s\|m\|h) |
        | --rollback-failure-action | pause | Action on rollback failure (“pause”\|”continue”)  |
        | --rollback-monitor | 5s | Duration after each task rollback to monitor for failure (ns\|us\|ms\|s\|m\|h) |
        | --rollback-order | stop-first | Rollback order (“start-first”\|”stop-first”) |
        | --rollback-parallelism | 1 | Maximum number of tasks rolled back simultaneously (0 to roll back all at once) |
        | --tty , -t |  | Allocate a pseudo-TTY |
        | --update-delay |  0s| Delay between updates (ns\|us\|ms\|s\|m\|h) |
        | --update-failure-action | pause | Action on update failure (“pause”\|”continue”\|”rollback”) |
        | --update-monitor | 5s | Duration after each task update to monitor for failure (ns\|us\|ms\|s\|m\|h) |
        | --update-order | stop-first | Update order (“start-first”\|”stop-first”) |
        | --update-parallelism | 1 | Maximum number of tasks updated simultaneously (0 to update all at once) |
        | --with-registry-auth |  | Send registry authentication details to swarm agents |
        | --workdir , -w |  | Working directory inside the container |
    
    - Ví dụ:

        - Để tạo ra service ta sử dụng câu lệnh như sau:

                docker service create --name redis redis:3.0.6

            hoặc tạo nó trong mode `global` (không thể scale), ta sử dụng câu lệnh:

                docker service create --mode global --name redis2 redis:3.0.6

        - Tạo ra service với 5 bản replicas:

                docker service create --name redis --replicas=5 redis:3.0.6

        - Khi ta tạo ra service đi kèm theo các ràng buộc (sử dụng `--constraint` flag). Ta có thể có các ràng buộc như sau:

            | Node attribute     | Matches | Example|
            | ------------- | ------------- |  ------------- |
            | node.id | Node ID | node.id==2ivku8v2gvtg4 |
            | node.hostname | Node hostname | node.hostname!=node-2 |
            | node.role | Node role | node.role==manager |
            | node.labels | user defined node labels | node.labels.security==high |
            | engine.labels | Docker Engine's labels | engine.labels.operatingsystem==ubuntu 14.04 |

            ví dụ:

                docker service create \
                  --name redis_2 \
                  --constraint 'node.role == manager' \
                  redis:3.0.6
            
            có nghĩa rằng service tạo ra chỉ có thể chạy trên node `manager`.

        - Tạo ra service với `expose port`, ta sử dụng câu lệnh như sau:

                docker service create \
                --name my_web \
                --replicas 3 \
                --publish published=8080,target=80 \
                nginx

- ### <a name="docker-service-inspect">10.2.2 Câu lệnh docker service inspect</a>
    - Sử dụng để hiển thị thông tin chi tiết về một hay nhiều service.
    - Cú pháp:

            docker service inspect [OPTIONS] SERVICE [SERVICE...]

        trong đó OPTIONS có thể bao gồm như sau:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --format , -f | | Format the output using the given Go template |
        | --pretty   |  | Print the information in a human friendly format |

    - Ví dụ:

            docker service inspect my_web

- ### <a name="docker-service-logs">10.2.3 Câu lệnh docker service logs</a>
    - Sử dụng để lấy logs từ service hay task
    - Cú pháp:

            docker service logs [OPTIONS] SERVICE|TASK

        trong đó OPTIONS có thể bao gồm như sau:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --details |  | Show extra details provided to logs |   
        | --follow , -f |  | Follow log output |   
        | --since |  | Show logs since timestamp (e.g. 2013-01-02T13:23:37) or relative (e.g. 42m for 42 minutes) |   
        | --tail | all | Number of lines to show from the end of the logs |   
        | --timestamps , -t |  | Show timestamps |   

    - Ví dụ:

            docker service logs my_web

- ### <a name="docker-service-ls">10.2.4 Câu lệnh docker service ls</a>
    - Sử dụng để liệt kê services
    - Cú pháp:

            docker service ls [OPTIONS]

        trong đó OPTIONS có thể bao gồm như sau:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --filter , -f |  | Filter output based on conditions provided |
        | --format |  | Pretty-print services using a Go template |
        | --quiet , -q |  | Only display IDs |

- ### <a name="docker-service-ps">10.2.5 Câu lệnh docker service ps</a>
    - Sử dụng để đưa ra tasks của một hay nhiều service.
    - Cú pháp:

            docker service ps [OPTIONS] SERVICE [SERVICE...]

        trong đó OPTIONS có thể bao gồm như sau:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --filter , -f |  | Filter output based on conditions provided |
        | --format |  | Pretty-print services using a Go template |
        | --quiet , -q |  | Only display IDs |

- ### <a name="docker-service-rm">10.2.6 Câu lệnh docker service rm</a>
    - Sử dụng để xóa đi một hay nhiều services
    - Cú pháp:

            docker service rm SERVICE [SERVICE...]

        ví dụ:

            docker service rm my_web

- ### <a name="docker-service-rollback">10.2.7 Câu lệnh docker service rollback</a>
    - Sử dụng để hoàn nguyên các thay đổi đối với cấu hình của service.
    - Cú pháp:

            docker service rollback [OPTIONS] SERVICE

        trong đó OPTIONS có thể bao gồm như sau:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --detach , -d |  | Exit immediately instead of waiting for the service to converge |
        | --quiet , -q |  | Suppress progress output |

- ### <a name="docker-service-scale">10.2.8 Câu lệnh docker service scale</a>
    - Sử dụng để Scale một hay nhiều replicated services
    - Cú pháp:

            docker service scale SERVICE=REPLICAS [SERVICE=REPLICAS...]

        trong đó OPTIONS có thể bao gồm như sau:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --detach , -d |  | Exit immediately instead of waiting for the service to converge |

    - Ví dụ:

            docker service scale backend=3 frontend=5

        kết quả sẽ hiển thị:

            backend scaled to 3
            frontend scaled to 5

- ### <a name="docker-service-update">10.2.9 Câu lệnh docker service update</a>
    - Cập nhật các thông tin liên quan đến service
    - Cú pháp:

            docker service update [OPTIONS] SERVICE

        trong đó OPTIONS phổ biến có thể bao gồm như sau:

        | Name, shorthand | Default | Mô tả|
        | ------------- | ------------- |  ------------- |
        | --constraint-add |  | Add or update a placement constraint |
        | --constraint-rm |  | Remove a constraint |
        | --container-label-add |  | Add or update a container label |
        | --container-label-rm |  | Remove a container label by its key |
        | --detach , -d |  | Exit immediately instead of waiting for the service to converge |
        | --dns-add |  | Add or update a custom DNS server |
        | --dns-option-add |  | Add or update a DNS option |
        | --dns-option-rm |  | Remove a DNS option |
        | --dns-rm |  | Remove a custom DNS server |
        | --dns-search-add |  | Add or update a custom DNS search domain |
        | --dns-search-rm |  | Remove a DNS search domain |
        | --endpoint-mode |  | Endpoint mode (vip or dnsrr) |
        | --env-add |  | Add or update an environment variable |
        | --env-rm |  | Remove an environment variable |
        | --force |  | Force update even if no changes require it |
        | --host-add |  | Add a custom host-to-IP mapping (host:ip) |
        | --host-rm |  | Remove a custom host-to-IP mapping (host:ip) |
        | --hostname |  | Container hostname |
        | --image |  | Service image tag |
        | --isolation |  | Service container isolation mode |
        | --limit-cpu |  | Limit CPUs |
        | --limit-memory |  | Limit Memory |
        | --mount-add |  | Add or update a mount on a service |
        | --mount-rm |  | Remove a mount by its target path |
        | --network-add |  | Add a network |
        | --network-rm |  | Remove a network |
        | --publish-add |  | Add or update a published port |
        | --publish-rm |  | Remove a published port by its target port |
        | --quiet , -q |  | Suppress progress output |
        | --read-only |  | Mount the container’s root filesystem as read only |
        | --replicas |  | Number of tasks |
        | --reserve-cpu |  | Reserve CPUs |
        | --reserve-memory |  | Reserve Memory |
        | --restart-condition |  | Restart when condition is met (“none”\|”on-failure”\|”any”) |

    - Ví dụ:

        + Chạy câu lệnh sau để expose port:

                docker service update \
                  --publish-add published=8080,target=80 \
                  myservice

        + Tăng số lượng bản sao về task service:

                docker service update --replicas=5 web

        + Quy trở lại status trước của service:

                docker service update --rollback web
                
____

# <a name="content-others">Các nội dung khác</a>
