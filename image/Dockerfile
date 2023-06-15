FROM docker.io/rockylinux:9.2

RUN dnf -y install 'dnf-command(config-manager)' && \
    dnf -y install epel-release && \
    dnf -y --allowerasing install curl gzip java-11-openjdk-headless supervisor tar && \
    dnf clean all && \
    curl -JLk -o /tmp/kafka_2.13-3.4.0.tgz https://archive.apache.org/dist/kafka/3.4.0/kafka_2.13-3.4.0.tgz && \
    tar -xzf /tmp/kafka_2.13-3.4.0.tgz -C /opt/ && \
    curl -JLk -o /opt/kafka_2.13-3.4.0/libs/jmx_prometheus_javaagent-0.17.2.jar https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.17.2/jmx_prometheus_javaagent-0.17.2.jar && \
    mv /opt/kafka_2.13-3.4.0/config/server{,-orig}.properties && \
    mv /opt/kafka_2.13-3.4.0/config/zookeeper{,-orig}.properties && \
    groupadd --system kafka && \
    useradd --gid kafka --no-create-home --no-user-group --system --shell /bin/false kafka

COPY kafka-jmx.yaml /opt/
COPY supervisord.conf /etc/supervisor/
COPY run.sh /opt/

RUN chown kafka:kafka -R /opt/kafka_2.13-3.4.0

USER kafka

ENTRYPOINT [ "/usr/bin/bash", "/opt/run.sh" ]
