#!/usr/bin/env bash

#set -xv

installdir=/root/.road-runner

if [ ! -d $installdir ]; then
    mkdir -p $installdir
fi

cd $installdir
rm *

# download dot files
wget https://raw.githubusercontent.com/rstober/dotfiles/main/cmshrc .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/bookmarks-cmsh .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/du.cmsh .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/si.cmsh .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/ansible.cfg .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/add-user.yaml .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/run-yum-update.yaml .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/clone-software-image.yaml .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/install-gnome-desktop.yaml .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/install-b4ds.yaml .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/clone-and-update-category.yaml .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/assign-nodes-to-category.yaml .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/configure-slurm.yaml .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/configure-usemarketplaceamis.yaml .

# download playbooks

# install
cp cmshrc /root/.cmshrc
cp bookmarks-cmsh /root/.bookmarks-cmsh
cp du.cmsh /root/.cm/cmsh/du.cmsh
cp si.cmsh /root/.cm/cmsh/si.cmsh
cp ansible.cfg /root/.ansible.cfg

# install the brightcomputing.bcm collection
# module load python3
# pip install ansible-base
# ansible-galaxy collection install brightcomputing.bcm

# must use the system python to use Ansible's built-in yum/dnf
# export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python
# ansible-playbook -ilocalhost, --flush-cache ${installdir}/run-yum-update.yaml

# must use the Bright python package to use the Bright collection
export ANSIBLE_PYTHON_INTERPRETER=/cm/local/apps/python3/bin/python
# ansible-playbook -ilocalhost, --flush-cache ${installdir}/clone-software-image.yaml

# clone the default category -> cloned set to use cloned-image
#ansible-playbook -ilocalhost, --flush-cache ${installdir}/clone-and-update-category.yaml

# assign cnode001..cnode004 to cloned category
ansible-playbook -ilocalhost, --flush-cache ${installdir}/assign-nodes-to-category.yaml

# configure slurm-client overlay and slurm-client role
ansible-playbook -ilocalhost, --flush-cache ${installdir}/configure-slurm.yaml

# allow use of marketplace amis
ansible-playbook -ilocalhost, --flush-cache ${installdir}/configure-usemarketplaceamis.yaml

# need to use the system python for dnf operations
export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python

# install B4DS into cloned software image
# ansible-playbook -ilocalhost, --flush-cache ${installdir}/install-b4ds.yaml

# install gnome desktop in cloned software image
# ansible-playbook -ilocalhost, --flush-cache ${installdir}/install-gnome-desktop.yaml

# create a set of users
# for user in robert david alice bob charlie edgar frank
# do
    # ansible-playbook -ilocalhost, --flush-cache --extra-vars "username=$user pass=6b3rl1n5 prof=cloudjob" ${installdir}/add-user.yaml
# done