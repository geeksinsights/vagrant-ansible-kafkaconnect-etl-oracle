# vagrant-ansible-kafkaconnect-etl-oracle
This repository will help to build and test the ETL pipleine with Kafka connect using JDBC Sink Connector. I have used oracle as jdbc source and hdfs as my target using kafka connect stream through a topic.

This will setup the entire environment and once ready you can test out the change data capture from sourc database to target. 

# Pre-Reqs

1. Playbook oracle12c.yml or oracle18c.yml require oracle database zip files in the clone directory, so download them from the oracle downloads
2. Require vagrant and oracle virtualbox to be installed in your machine

# Installation

1. Download the repository
2. Run Vagrant
    vagrant up
3. vagrant ssh
    cd /vagrant
    ansible-playbook oracle12c.yml
    ansible-playbook ansible-kafka-etl-solution.yml
    
4. Once the playbook completed, you can now setup the hadoop, kafka, hive metastore using below
    sudo su - root
    cd /vagrant
    ./start.sh

5. Now run the kafka-connect in standalone mode, this will integrate , oracle database to kafka topic and stream data to hdfs partitions, hive metastore will be used as schema registry to obtain latest schema structure from oracle database to hdfs.


   
