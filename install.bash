#!/usr/bin/env bash

set -xv

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

# download playbooks

# install
cp cmshrc /root/.cmshrc
cp bookmarks-cmsh /root/.bookmarks-cmsh
cp du.cmsh /root/.cm/cmsh/du.cmsh
cp si.cmsh /root/.cm/cmsh/si.cmsh
cp ansible.cfg /root/.ansible.cfg

module load python3

pip install ansible-base

ansible-galaxy collection install brightcomputing.bcm

ansible-playbook -ilocalhost, --flush-cache ${installdir}/run-yum-update.yaml

# for user in robert david alice bob charlie edgar frank
# do
    # ansible-playbook -ilocalhost, --flush-cache --extra-vars "username=$user pass=6b3rl1n5 prof=cloudjob" ${installdir}/add-user.yaml
# done