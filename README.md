## Syslog-ng in Alpine Docker

### Basic Info
Minimal syslog-ng container that writes logs to `/var/log/syslog-ng/$HOST/$PROGRAM.log`.

Modified from [karantin2020/docker-syslog-ng](https://github.com/karantin2020/docker-syslog-ng), and the [balabit docker image's](https://github.com/balabit/syslog-ng-docker) config file (which isn't included in that build...)

Includes a default config file if none specified, or alternatively use your own by binding `/etc/syslog-ng`.

Uses Tini for monitoring

Exposed inputs:

* 514/udp
* 601/tcp 
* 6514/TLS
* unix socket `/var/run/syslog-ng/syslog-ng.sock`

Exposed Volumes:
* `/var/log/syslog-ng` (Actual logging location)
* `/var/run/syslog-ng` (Unix Socket)
* `/etc/syslog-ng` (Config File)

#### Usage

Listen on udp port 514 and save logs to `/var/log/syslog-ng`:

```bash
docker run --name syslog-ng -it -d -p 514:514/udp \
    -v /var/log/syslog-ng:/var/log/syslog-ng \
   mumblepins/syslog-ng-alpine

```

#### Docker-compose example
```yml
version: '3'
services:
  syslog-ng:
    container_name: syslog-ng
    build: .
    ports:
      - "514:514"
      - "601:601"
      - "6514:6514"
    volumes:
      - "./syslog-ng/logs:/var/log/syslog-ng"
      - "./syslog-ng/socket:/var/run/syslog-ng"
      - "./syslog-ng/config/:/etc/syslog-ng"
```

## docker yaml with docker-gen

~~~yaml
syslog-ng:
  image: index.docker.io/tekintian/syslog-ng-alpine:latest
  privileged: false
  restart: always
  ports:
  - 514:514/udp
  - '6514'
  - 601:601
  volumes:
  - /home/syslog-ng/conf:/etc/syslog-ng
  - /home/syslog-ng/log:/var/log/syslog-ng
  - /home/syslog-ng/socket:/var/run/syslog-ng
  environment:
  - VIRTUAL_PORT=601
  - VIRTUAL_PROTO=http
  - VIRTUAL_HOST=logs.yunnan.ws

~~~

docker run --name syslog-ng -it -d -p 514:514/udp -v /var/log/syslog-ng:/var/log/syslog-ng tekintian/syslog-ng-alpine


