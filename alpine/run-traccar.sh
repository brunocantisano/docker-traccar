docker run \
        -d --restart always \
        --name traccar \
        --hostname traccar \
        -p 80:8082 \
        -p 5000-5150:5000-5150 \
        -p 5000-5150:5000-5150/udp \
        -v /etc/timezone:/etc/timezone:ro \
        -v /etc/localtime:/etc/localtime:ro \
        -v ~/arquivos/traccar/logs:/opt/traccar/logs:rw \
        -v ~/arquivos/traccar/traccar.xml:/opt/traccar/conf/traccar.xml:ro \
        devcant/traccar-alpine:3.17
