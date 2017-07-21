#!/bin/bash

# exit on any error
# set -e

help()
{

    echo "This script install Jenkins master on an Ubuntu VM image"
    echo "Parameters:"
    echo "-n number of slave nodes to configure on the master"
    echo "-h view this help content"
}

#Log method to control/redirect log output
log()
{
    echo "$1" >> /test.txt
}

test_script()
{
    touch /test.txt
}


log "Begin VMSS install script"

# Install docker
install_docker()
{
    log "Installing docker - start"
    
    apt-get -y update
    apt-get -y install docker.io
    apt-get -y update
	
    log "Installing docker - Done"
	
}

# Install jenkins master
install_nginx()
{
    log "Installing nginx - start"

    # update package source
	apt-get -y update

	# install NGINX
	apt-get -y install --assume-yes nginx

	systemctl enable nginx

	cp nginx  /etc/nginx/sites-enabled/default

	systemctl start nginx

	systemctl status nginx
    
    log "Installing nginx - done"
}


test_script

install_docker

install_nginx


exit 0




