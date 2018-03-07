#!/usr/bin/env bash

set -e
set -o pipefail

log()
{
    echo "$1" >> $HOME/startup_up_script_log.txt
}

test_script()
{
    touch $HOME/startup_up_script_log.txt
}

install_docker()
{
  log "Installing Docker - Start"
  sudo apt-get -y update
  sudo apt-get -y install docker.io
  sudo apt-get -y update
  log "Installing Docker - Done"
}

add_user_to_docker()
{
  log "Adding the logged in user to the docker group : $USER"
  id
  sudo adduser $USER docker
  sudo usermod -aG docker $USER
 }

docker_login()
{
  # Login to the docker account
  docker login -u traviscm -p lqnk2net
  docker ps
 }

deploy_fluentd()
{
  log "deploying fluentd - start"
  wget "https://cminfra.blob.core.windows.net/fluentd/fluentd.conf" --output-document fluentd.conf
  # Pull the fluentd image..
  docker pull civilmapsproduction/cm-log-webservice:fluentd
  # start the fluentd service..
  docker run -d --name fluentd-service -p 24224:24224 -v `pwd`:/fluentd/etc -e FLUENTD_CONF=fluentd.conf civilmapsproduction/cm-log-webservice:fluentd
  docker ps -a
  log "deploying fluentd - Done"
 }

mount_efs()
{
  log "Mounting the Azure File System (EFS) - Start"
  sudo apt-get -y update
  sudo apt-get -y install cifs-utils
  sudo mkdir /mnt/azure-efs
  sudo chown $USER /mnt/azure-efs
  sudo mount -t cifs //efsonazure.file.core.windows.net/worker-nodes-master /mnt/azure-efs -o vers=3.0,username=efsonazure,password=LBZ3TNxvnBWDJe/JFFRVcjsf1qqus2R1akJH+drAWKJlQqkVUrxAQxRpiUGTQD5HFpS+PwCc0fkdH+qxMqlzjA==,dir_mode=0777,file_mode=0777,sec=ntlmssp
  log "Mounting the Azure File System (EFS) - Done"
 }

test_script
install_docker
add_user_to_docker
docker_login
deploy_fluentd
mount_efs

exit 0
