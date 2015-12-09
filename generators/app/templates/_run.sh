#!/bin/sh
<% if (prodDatabaseType == 'mysql') {%>
################################################################################
# MySQL
################################################################################
if [ -d ${SPRING_DATASOURCE_URL} ]; then
    echo "SPRING_DATASOURCE_URL autoconfigured by docker link"
    SPRING_DATASOURCE_URL="jdbc:mysql://${MYSQL_PORT_3306_TCP_ADDR}:${MYSQL_PORT_3306_TCP_PORT}/<%=baseName%>?useUnicode=true&characterEncoding=utf8"
else
    echo "SPRING_DATASOURCE_URL init by configuration"
fi
<% } if (prodDatabaseType == 'postgresql') {%>
################################################################################
# PostgreSQL
################################################################################
if [ -d ${SPRING_DATASOURCE_URL} ]; then
    echo "SPRING_DATASOURCE_URL autoconfigured by docker link"
    SPRING_DATASOURCE_URL="jdbc:postgresql://${POSTGRESQL_PORT_5432_TCP_ADDR}:${POSTGRESQL_PORT_5432_TCP_PORT}/<%=baseName%>"
else
    echo "SPRING_DATASOURCE_URL init by configuration"
fi
<% } if (prodDatabaseType == 'mongodb') {%>
################################################################################
# MongoDB
################################################################################
if [ -d ${SPRING_DATA_MONGODB_HOST} ]; then
    echo "SPRING_DATA_MONGODB_HOST autoconfigured by docker link"
    SPRING_DATA_MONGODB_HOST=${MONGODB_PORT_27017_TCP_ADDR}
else
    echo "SPRING_DATA_MONGODB_HOST init by configuration"
fi
if [ -d ${SPRING_DATA_MONGODB_PORT} ]; then
    echo "SPRING_DATA_MONGODB_PORT autoconfigured by docker link"
    SPRING_DATA_MONGODB_PORT=${MONGODB_PORT_27017_TCP_PORT}
else
    echo "SPRING_DATA_MONGODB_PORT init by configuration"
fi
<% } if (prodDatabaseType == 'mongodb') {%>
################################################################################
# Cassandra
################################################################################
if [ -d ${SPRING_DATA_CASSANDRA_CONTACTPOINTS} ]; then
    echo "SPRING_DATA_CASSANDRA_CONTACTPOINTS autoconfigured by docker link"
    SPRING_DATA_CASSANDRA_CONTACTPOINTS=${CASSANDRA_PORT_9042_TCP_ADDR}
else
    echo "SPRING_DATA_CASSANDRA_CONTACTPOINTS init by configuration"
fi
<% } if (searchEngine == 'elasticsearch') {%>
################################################################################
# ElasticSearch
################################################################################
if [ -d ${SPRING_DATA_ELASTICSEARCH_CLUSTER_NODES} ]; then
    echo "SPRING_DATA_ELASTICSEARCH_CLUSTER_NODES autoconfigured by docker link"
    SPRING_DATA_ELASTICSEARCH_CLUSTER_NODES="${ELASTIC_PORT_9300_TCP_ADDR}:${ELASTIC_PORT_9300_TCP_PORT}"
else
    echo "SPRING_DATA_ELASTICSEARCH_CLUSTER_NODES init by configuration"
fi
<% } %>

echo "(DEBUG) ${SPRING_DATASOURCE_URL}"
echo "(DEBUG) ${SPRING_DATA_ELASTICSEARCH_CLUSTER_NODES}"
echo "(DEBUG) ${SPRING_DATA_MONGODB_HOST}"
echo "(DEBUG) ${SPRING_DATA_MONGODB_PORT}"
################################################################################
# Start application
################################################################################
if [ -d ${JHIPSTER_SLEEP} ]; then
    JHIPSTER_SLEEP=20
fi
echo "The application will start in ${JHIPSTER_SLEEP}sec..." && sleep ${JHIPSTER_SLEEP}
java -jar /app.war \
    --spring.profiles.active=prod \<% if (searchEngine == 'elasticsearch') {%>
    --spring.data.elasticsearch.cluster-nodes=${SPRING_DATA_ELASTICSEARCH_CLUSTER_NODES} \<%} if (prodDatabaseType == 'mysql' || prodDatabaseType == 'postgresql') {%>
    --spring.datasource.url=${SPRING_DATASOURCE_URL}<%} if (prodDatabaseType == 'mongodb') {%>
    --spring.data.mongodb.host=${SPRING_DATA_MONGODB_HOST} \
    --spring.data.mongodb.port=${SPRING_DATA_MONGODB_PORT}<%} if (prodDatabaseType == 'cassandra') {%>
    --spring.data.cassandra.contactpoints=${SPRING_DATA_CASSANDRA_CONTACTPOINTS}
<% } %>