#!/bin/bash

if [ ! -e /opt/kafka_2.13-3.4.0/config/server.properties ]; then
    cat > /opt/kafka_2.13-3.4.0/config/server.properties <<EOF
broker.id = $1

group.initial.rebalance.delay.ms = 0

log.dirs = /tmp/kafka-logs
log.retention.check.interval.ms = 300000
log.retention.hours = 168

num.io.threads = 8
num.network.threads = 3
num.partitions = 1
num.recovery.threads.per.data.dir = 1

offsets.topic.replication.factor = 1

socket.request.max.bytes = 104857600
socket.send.buffer.bytes = 102400

transaction.state.log.min.isr = 1
transaction.state.log.replication.factor = 1

zookeeper.connect = localhost:2181
zookeeper.connection.timeout.ms = 18000
EOF
fi

shift 1

if [ ! -e /opt/kafka_2.13-3.4.0/config/zookeeper.properties ]; then
    cat > /opt/kafka_2.13-3.4.0/config/zookeeper.properties <<EOF
admin.enableServer = false

clientPort = 2181

dataDir = /tmp/zookeeper

tickTime=2000
initLimit=5
syncLimit=2

EOF
    for i in $@; do
	cat >> /opt/kafka_2.13-3.4.0/config/zookeeper.properties <<EOF
server.$i = $i:2188:3888
EOF
    done
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
