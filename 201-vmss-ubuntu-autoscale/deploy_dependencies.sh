#!/usr/bin/env bash

set -e
set -o pipefail

echo "Installing Docker - Start"
sudo apt-get -y update
sudo apt-get -y install docker.io
sudo apt-get -y update
echo "Installing Docker - Done"


echo "Adding the logged in user to the docker group : $USER"
id
sudo adduser $USER docker
sudo usermod -aG docker $USER

sudo adduser _azbatch docker
sudo usermod -aG docker _azbatch
id

# Login to the docker account
docker login -u traviscm -p lqnk2net
docker ps

echo "deploying fluentd - start"
wget "https://cminfra.blob.core.windows.net/fluentd/fluentd.conf" --output-document fluentd.conf
# Pull the fluentd image..
docker pull civilmapsproduction/cm-log-webservice:fluentd
# start the fluentd service..
docker run -d --name fluentd-service -p 24224:24224 -v `pwd`:/fluentd/etc -e FLUENTD_CONF=fluentd.conf civilmapsproduction/cm-log-webservice:fluentd
docker ps -a
echo "deploying fluentd - Done"

echo "Mounting the Azure File System (EFS) - Start"
sudo apt-get -y update
sudo apt-get -y install cifs-utils
sudo mkdir /mnt/azure-efs
sudo chown $USER /mnt/azure-efs
sudo mount -t cifs //efsonazure.file.core.windows.net/worker-nodes-master /mnt/azure-efs -o vers=3.0,username=efsonazure,password=LBZ3TNxvnBWDJe/JFFRVcjsf1qqus2R1akJH+drAWKJlQqkVUrxAQxRpiUGTQD5HFpS+PwCc0fkdH+qxMqlzjA==,dir_mode=0777,file_mode=0777,sec=ntlmssp
echo "Mounting the Azure File System (EFS) - Done"
