FROM centos:latest

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.12
ENV KAFKA_VERSION 2.8.0
ENV ZOOKEEPER_VERSION 0.10.1.0
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"


RUN dnf update -y
RUN dnf install epel-release -y
RUN dnf install java wget vim -y
RUN wget https://downloads.apache.org/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz
RUN tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

RUN yum -y install supervisor telnet net-tools
# RUN sed 's/KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"/KAFKA_HEAP_OPTS="-Xmx1G -Xms128M"' /opt/
RUN ls -l /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"/bin/
# RUN ls -l /etc/supervisor/conf.d/
# RUN ls -l /etc/supervisor/
# RUN cat /etc/supervisor.conf

# RUN systemctl cat  supervisord

RUN java -version

ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
# ADD supervisor/kafka.conf supervisor/zookeeper.conf /etc/supervisor/conf.d/

# 2181 is zookeeper, 9092 is kafka
EXPOSE 2181 9092

# CMD ["supervisord", "-n"]

RUN chmod +x /usr/bin/start-kafka.sh
ENTRYPOINT ["start-kafka.sh"]
