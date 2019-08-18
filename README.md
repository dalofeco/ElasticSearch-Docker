# ElasticSearch-Docker

Two images are built from this repository, one for the **master** node and another for the **slave** nodes. They are made to be deployed in a docker swarm with the provided docker-compose file. Feel free to adjust the number of replicas for the slave nodes.

#### Pulling the images from Docker Hub
- **Master**: Run `docker pull dalofeco/elasticsearch_master`
- **Slave**: Run `docker pull dalofeco/elasticsearch_slave`

#### Persistant Volume Across Swarm
The master node must be run on the swarm manager, as specified in the docker-compose config, in order to have the persistant *esdata* docker volume where the database data and backups are stored.

#### Linux Security Notice
These images run as a user with UID and GID of 1021. Make sure to create a local user with this uid and gid on your host Linux machine. 
