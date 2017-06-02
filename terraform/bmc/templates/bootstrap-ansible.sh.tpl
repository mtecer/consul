#!/bin/bash -x

ANSIBLE_USER='opc'
GITREPO="https://github.com/mtecer/consul.git"

cat << HERE > /home/$${ANSIBLE_USER}/.ssh/ansible-key
${ssh_private_key}
HERE

cat << HERE > /home/$${ANSIBLE_USER}/.ssh/config
Host *
    ServerAliveInterval 60
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
    User $${ANSIBLE_USER}
    IdentityFile /home/$${ANSIBLE_USER}/.ssh/ansible-key
HERE

chown $${ANSIBLE_USER}.$${ANSIBLE_USER} /home/$${ANSIBLE_USER}/.ssh/ansible-key
chown $${ANSIBLE_USER}.$${ANSIBLE_USER} /home/$${ANSIBLE_USER}/.ssh/config

chmod 0400 /home/$${ANSIBLE_USER}/.ssh/ansible-key
chmod 0400 /home/$${ANSIBLE_USER}/.ssh/config

cat /home/$${ANSIBLE_USER}/.ssh/authorized_keys > /root/.ssh/authorized_keys

if ! rpm -q --quiet git; then
    echo "Installing git"
    yum -y install git
else
    echo "git is already installed"
fi

if [ ! -d /home/$${ANSIBLE_USER}/ansible ]; then
    echo "Configuring ansible"
    git clone $${GITREPO} /home/$${ANSIBLE_USER}/ansible
else
    echo "Updating git repo in /home/$${ANSIBLE_USER}/ansible"
    cd /home/$${ANSIBLE_USER}/ansible && git pull
fi

if [ ! -d /ansible ]; then
    ln -s /home/$${ANSIBLE_USER}/ansible/ansible /ansible
    chown -R $${ANSIBLE_USER}.$${ANSIBLE_USER} /home/$${ANSIBLE_USER}/ansible
fi

if ! rpm -q --quiet epel-release ansible; then
    echo "Installing ansible"
    rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
    yum -y install epel-release
    yum -y install ansible net-tools bind-utils
else
    echo "Ansible is already installed"
fi

ln -f -s /home/opc/hosts /ansible/environments/dev/hosts

cd /ansible
ansible-galaxy install -r /ansible/requirements.yaml --roles-path /ansible/roles
# ansible -m ping all
# ansible-playbook playbook.yaml

# consul members
# consul operator raft -list-peers
