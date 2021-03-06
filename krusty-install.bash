#!/usr/bin/env bash

#set -xv

installdir=/root/.road-runner
ansible_version='2.10.*'

if [ ! -d $installdir ]; then
    mkdir -p $installdir
fi

cd $installdir && rm -rf $installdir/*

yum install -y git

git clone https://github.com/rstober/dotfiles.git $installdir

module load python3
pip install ansible==${ansible_version}

# install the brightcomputing.bcm collection
ansible-galaxy collection install brightcomputing.bcm

# install
cp cmshrc /root/.cmshrc
cp bookmarks-cmsh /root/.bookmarks-cmsh
cp du.cmsh /root/.cm/cmsh/du.cmsh
cp cu.cmsh /root/.cm/cmsh/cu.cmsh
cp si.cmsh /root/.cm/cmsh/si.cmsh
cp dp.cmsh /root/.cm/cmsh/dp.cmsh
cp ansible.cfg /root/.ansible.cfg

# install the AWS CLI
# unzip awscliv2.zip
# ./aws/install

# must use the system python to use Ansible's built-in yum/dnf
export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python

# dnf update the head node and the default software image
#ansible-playbook -ilocalhost, --flush-cache ${installdir}/run-yum-update.yaml

# must use the Bright python package to use the Bright collection
export ANSIBLE_PYTHON_INTERPRETER=/cm/local/apps/python3/bin/python
ansible-playbook -ilocalhost, --flush-cache ${installdir}/krusty-clone-software-image.yaml

# install B4DS into cloned software image
export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python
ansible-playbook -ilocalhost, --flush-cache ${installdir}/krusty-install-b4ds.yaml

# # install gnome desktop in cloned software image
ansible-playbook -ilocalhost, --flush-cache ${installdir}/krusty-install-gnome-desktop.yaml

export ANSIBLE_PYTHON_INTERPRETER=/cm/local/apps/python3/bin/python

# clone the default category -> cloned set to use cloned-image
# nodes have to be powered off for thsi to work
ansible-playbook -ilocalhost, --flush-cache ${installdir}/krusty-clone-and-update-category.yaml

# assign cnode001..cnode004 to cloned category
ansible-playbook -ilocalhost, --flush-cache ${installdir}/krusty-assign-nodes-to-category.yaml

# configure slurm-client overlay and slurm-client role
ansible-playbook -ilocalhost, --flush-cache ${installdir}/krusty-configure-slurm.yaml

# configure auto scaler
ansible-playbook -ilocalhost, --flush-cache ${installdir}/krusty-configure-auto-scaler.yaml

# install Jupyter
ansible-playbook -ilocalhost, --flush-cache ${installdir}/krusty-install-jupyter.yaml

# install the jobs the users will run-yum
ansible-playbook -ilocalhost, --flush-cache --extra-vars "installdir=$installdir"  ${installdir}/install-apps.yaml

pass=$(tr -cd '0-9a-zA-Z!@#$%^' < /dev/urandom | fold -w${1-32} | head -n1)
echo $pass > /root/.userpassword
chmod 400 /root/.userpassword
# create a set of users
for user in robert david alice charlie edgar frank
do
    ansible-playbook -ilocalhost, --flush-cache --extra-vars "user=$user pass=$pass" ${installdir}/add-user.yaml
done