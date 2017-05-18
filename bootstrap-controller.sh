#!/bin/bash

GITREPO="https://github.com/mtecer/consul.git"

if ! rpm -q --quiet epel-release ansible; then
    echo "Installing ansible"
    sudo -- bash -c '
    rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
    yum -y install epel-release
    yum -y install ansible git net-tools'
else
    echo "Ansible is already installed"
fi

if [ ! -d /ansible ]; then
    echo "Configuring ansible"
    git clone ${GITREPO} /ansible
else
    echo "Updating git repo in /ansible"
    cd /ansible && git pull
fi

sudo chown -R vagrant.vagrant /ansible
