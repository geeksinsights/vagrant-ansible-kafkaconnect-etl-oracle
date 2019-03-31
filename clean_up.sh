#!/bin/bash
set -e

# Shutdown Confluent Platform
echo "Shutting down Confluent Platform"
schema-registry-stop /mnt/etc/schema-registry.properties 1>> /mnt/logs/schema-registry.log 2>> /mnt/logs/schema-registry.log &
kafka-server-stop /mnt/etc/server.properties 1>> /mnt/logs/kafka.log 2>> /mnt/logs/kafka.log &
zookeeper-server-stop /mnt/etc/zookeeper.properties 1>> /mnt/logs/zk.log 2>>/mnt/logs/zk.log &
#systemctl start confluent-ksql
#systemctl stop confluent-schema-registry
#systemctl stop confluent-kafka
#systemctl stop confluent-zookeeper

# Shutdown Hadoop
echo "Shutting down Hadoop"
hadoop-daemon.sh stop datanode
hadoop-daemon.sh stop namenode

# Shutdown Hive Metastore
echo "Shutting down Hive Metastore"
#killall java

# Clean up data
echo "Cleaning up data"
rm -rf /mnt/kafka-logs/
rm -rf /mnt/zookeeper/
rm -rf /mnt/dfs/name/*
rm -rf /mnt/dfs/data/*
rm -rf /mnt/connect.offsets
rm -rf /mnt/logs/*
rm -rf /var/lib/zookeeper/*
rm -rf /var/lib/kafka/*

#Dropping Hive metastore schema and test schema in oracle
echo "Dropping Hive metastore and Test schema in Oracle"

#sudo su - oracle
export ORACLE_SID=db12c
export ORACLE_HOME=/opt/oracle/product/12.2.0/db_home1
export PATH=$PATH:$ORACLE_HOME/bin
cd /vagrant
sudo su - oracle -c "cd /vagrant;export ORACLE_SID=db12c;export ORACLE_HOME=/opt/oracle/product/12.2.0/db_home1;export PATH=$PATH:$ORACLE_HOME/bin;sqlplus -s / as sysdba << EOF
whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off
drop user test cascade;
drop user hive cascade;

exit;
EOF
"
