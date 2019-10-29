ARG VERSION=2.7.7
FROM gradiant/hadoop-base:$VERSION

LABEL maintainer="cgiraldo@gradiant.org"
LABEL organization="gradiant.org"

COPY run.sh /run.sh

ENV CLUSTER_NAME hadoop
ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN adduser -D -S -u 1000 -G root hdfs && \
    mkdir -p /hadoop/dfs/name && \
    chown -R hdfs:root /hadoop && \
    chown -R hdfs:root $HADOOP_CONF_DIR

USER hdfs

VOLUME /hadoop

CMD ["/run.sh"]
[root@localhost namenode]# cd ../datanode/
[root@localhost datanode]# ls
Dockerfile  run.sh
[root@localhost datanode]# cat run.sh
#!/bin/bash

if [ -z "$HDFS_NAMENODE_URL" ] && [ -z "$CORE_CONF_fs_defaultFS" ]; then
  echo "hdfs namenode url not specified"
  echo "Use HDFS_NAMENODE_URL or CORE_CONF_fs_defaultFS to specify hdfs namenode url"
  exit 2
fi

datadir=${HDFS_CONF_dfs_datanode_data_dir#"file://"}
if [ ! -d $datadir ]; then
  echo "Datanode data directory not found: $datedir"
  exit 2
fi

$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR datanode
