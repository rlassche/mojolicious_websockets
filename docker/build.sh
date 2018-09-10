#!/bin/bash

. config.sh 
docker ps | grep $DOCKERIMG | \
	docker kill $DOCKERIMG

docker ps -a | grep $DOCKERIMG | \
	docker rm $DOCKERIMG

docker build --tag $DOCKERIMG:v1 .

cat<<!
docker run -d -h $DOCKERIMG -p 9090:9090 ${NETWORK} -v /tmp/share:/mnt --name $DOCKERIMG $DOCKERIMG:v1
!
docker run -d -h $DOCKERIMG -p 9090:9090 ${NETWORK} -v /tmp/share:/mnt --name $DOCKERIMG $DOCKERIMG:v1
