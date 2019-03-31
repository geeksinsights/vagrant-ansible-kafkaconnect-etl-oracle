#!/bin/bash
set -e
source /home/vagrant/.bash_profile

echo "setting up hive metastore and test schema in oracle database"
cd /vagrant
sudo su - oracle -c "cd /vagrant;export ORACLE_SID=db12c;export ORACLE_HOME=/opt/oracle/product/12.2.0/db_home1;export PATH=$PATH:$ORACLE_HOME/bin;/opt/oracle/product/12.2.0/db_home1/bin/sqlplus -s / as sysdba << EOF
whenever sqlerror exit sql.sqlcode;
set echo off
set heading off

@oracle_setup2.sql

exit;
EOF
"

#echo Initializing hive metastore in oracle
schematool -dbType oracle -initSchema -verbose

cd /opt/confluent/share/java/kafka-connect-jdbc
#ln -s /usr/share/java/ojdbc8.jar ojdbc8.jar
#ln -s /usr/share/java/mysql-connector-java-8.0.12.jar mysql-connector-java.jar

# Starting Hadoop
echo "Starting Hadoop"
hadoop namenode -format -force -nonInteractive
hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode

# Starting Confluent Platform
echo "Starting Confluent Platform"
/opt/confluent/bin/zookeeper-server-start /mnt/etc/zookeeper.properties 1>> /mnt/logs/zk.log 2>>/mnt/logs/zk.log &
#systemctl start confluent-zookeeper
sleep 5

/opt/confluent/bin/kafka-server-start /mnt/etc/server.properties 1>> /mnt/logs/kafka.log 2>> /mnt/logs/kafka.log &
#systemctl start confluent-kafka
sleep 10


/opt/confluent/bin/schema-registry-start /mnt/etc/schema-registry.properties 1>> /mnt/logs/schema-registry.log 2>> /mnt/logs/schema-registry.log &
#systemctl start confluent-schema-registry
sleep 5

#systemctl start confluent-kafka-connect
#systemctl start confluent-ksql
#/opt/confluent/bin/ksql-server-start /opt/confluent/etc/ksql/ksql-server.properties


# Starting Hive Metastore
echo "Starting Hive metastore"
hive --service metastore 1>> /mnt/logs/metastore.log 2>> /mnt/logs/metastore.log &
