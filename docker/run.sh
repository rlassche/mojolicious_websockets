. config.sh
docker run -d -h $DOCKERIMG -v /tmp/share:/mnt --name $DOCKERIMG $DOCKERIMG:v1
