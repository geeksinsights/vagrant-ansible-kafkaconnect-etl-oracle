#!/bin/bash
set -e
#export CLASSPATH=$CLASSPATH:/opt/hive/lib/mysql-connector-java.jar
#mysql -u root --password="mypassword" < /vagrant/create_users.sql

schematool -dbType oracle -initSchema -verbose

