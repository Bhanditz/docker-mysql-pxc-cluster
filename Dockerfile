FROM m3hran/baseimage
MAINTAINER Martin Taheri <m3hran@gmail.com>
LABEL Description="PXC Galera DB Image"

ENV PERCONA_RELEASE=0.1-5
ENV XTRADB_CLUSTER_VER=57

RUN wget https://repo.percona.com/apt/percona-release_$PERCONA_RELEASE.$(lsb_release -sc)_all.deb
RUN dpkg -i percona-release_$PERCONA_RELEASE.$(lsb_release -sc)_all.deb

RUN clean_install.sh percona-xtradb-cluster-$XTRADB_CLUSTER_VER xinetd
RUN rm -rf /var/log/mysql* /var/lib/mysql/* /etc/mysql/* /u/apps && chown -R mysql: /var/lib/mysql
RUN echo "mysqlchk 9200/tcp # MySQL check" >> /etc/services

WORKDIR /u/apps
#3306 For MySQL client connections and State Snapshot Transfer that use the mysqldump method.
#4567 For Galera Cluster replication traffic, multicast replication uses both UDP transport and TCP on this port.
#4568 For Incremental State Transfer.
#4444 For all other State Snapshot Transfer.
#9200 For MySQL check
EXPOSE 3306 4567 4568 4444 9200/tcp


