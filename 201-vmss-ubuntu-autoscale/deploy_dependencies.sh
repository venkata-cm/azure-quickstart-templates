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
    echo "$1"
}

test_script()
{
    touch /test.txt
}


log "Begin VMSS install script"


# Install openjdk-7
install_java()
{
    log "Installing openjdk-7"
    apt-get -y update 
    apt-get -y install openjdk-7-jdk 
    apt-get -y update 
}


# Primary Install Tasks
install_java

test_script


exit 0




