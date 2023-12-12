ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN : \
  && apt-get update -y \
  && apt-get install -y libsnappy1v5 gettext-base libjemalloc-dev curl \
  && :

# Used by the official entrypoint script to switch to a non-root user
# See https://github.com/apache/flink-docker/blob/fce2e96cea2ef6ced375c113486db5cbb02e0480/1.17/scala_2.12-java11-ubuntu/docker-entrypoint.sh#L28C1-L28C22
# I'll probably remove this later as I deviate from the official container.
ARG GOSU_VERSION=1.11
ARG GOSU_URL=https://github.com/tianon/gosu/releases/download/$GOSU_VERSION
RUN : \
  && curl -LSso /usr/local/bin/gosu $GOSU_URL/gosu-$(dpkg --print-architecture) \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true \
  && :

ARG SCALA_VERSION
ARG FLINK_VERSION
ENV FLINK_HOME=/opt/flink
ENV PATH=$FLINK_HOME/bin:$PATH
ENV FLINK_URL=https://www.apache.org/dyn/closer.cgi?action=download&filename=flink/flink-$FLINK_VERSION/flink-$FLINK_VERSION-bin-scala_$SCALA_VERSION.tgz

RUN : \
  && groupadd --system --gid=9999 flink \
  && useradd --system --home-dir $FLINK_HOME --uid=9999 --gid=flink flink \
  && :

# Flink also has an opt/python directory that has what appears to be the compiled python libraries for
# pyflink and a couple others.  It appears to be redundant to what we are doing so I may remove it later
# to shrink the image size.
WORKDIR $FLINK_HOME
RUN : \
  && curl -LSso /tmp/flink.tgz $FLINK_URL \
  && tar --strip-components=1 -xvf /tmp/flink.tgz \
  && chown -R flink:flink $FLINK_HOME \
  && sed -i 's/rest.address: localhost/rest.address: 0.0.0.0/g' $FLINK_HOME/conf/flink-conf.yaml \
  && sed -i 's/rest.bind-address: localhost/rest.bind-address: 0.0.0.0/g' $FLINK_HOME/conf/flink-conf.yaml \
  && sed -i 's/jobmanager.bind-host: localhost/jobmanager.bind-host: 0.0.0.0/g' $FLINK_HOME/conf/flink-conf.yaml \
  && sed -i 's/taskmanager.bind-host: localhost/taskmanager.bind-host: 0.0.0.0/g' $FLINK_HOME/conf/flink-conf.yaml \
  && sed -i '/taskmanager.host: localhost/d' $FLINK_HOME/conf/flink-conf.yaml \
  && :

RUN : \
  && curl -LSso /entrypoint.sh https://raw.githubusercontent.com/apache/flink-docker/master/1.17/scala_2.12-java11-ubuntu/docker-entrypoint.sh \
  && chmod +x /entrypoint.sh \
  && :

RUN : \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && :

USER flink
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 6123 8081
CMD ["help"]
