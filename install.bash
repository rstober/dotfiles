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

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

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

install the AWS CLI
unzip awscliv2.zip
./aws/install

# must use the system python to use Ansible's built-in yum/dnf
#export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python

# dnf update the head node and the default software image
#ansible-playbook -ilocalhost, --flush-cache ${installdir}/run-yum-update.yaml

# must use the Bright python package to use the Bright collection
export ANSIBLE_PYTHON_INTERPRETER=/cm/local/apps/python3/bin/python

# create software images
ansible-playbook -ilocalhost, --flush-cache clone-software-image.yaml

# create and update categories
ansible-playbook -ilocalhost, --flush-cache clone-and-update-category.yaml

# assign nodes to categories
# cnode001 -> k8s
# cnode002 -> jup
# cnode003..cnode004 -> cloned
ansible-playbook -ilocalhost, --flush-cache assign-nodes-to-category.yaml

# install B4DS into cloned software image
export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python
ansible-playbook -ilocalhost, --flush-cache install-b4ds.yaml

# install gnome desktop in cloned software image
ansible-playbook -ilocalhost, --flush-cache install-gnome-desktop.yaml

# placeholder - power on nodes and gather facts
export ANSIBLE_PYTHON_INTERPRETER=/cm/local/apps/python3/bin/python
ansible-playbook -ilocalhost, --flush-cache install-k8s.yaml

# configure slurm-client overlay and slurm-client role
ansible-playbook -ilocalhost, --flush-cache configure-slurm.yaml

# configure auto scaler
ansible-playbook -ilocalhost, --flush-cache configure-auto-scaler.yaml

# allow use of marketplace amis
ansible-playbook -ilocalhost, --flush-cache configure-usemarketplaceamis.yaml

# install Jupyter
ansible-playbook -ilocalhost, --flush-cache install-jupyter.yaml

# create a set of users
pass=$(tr -cd '0-9a-zA-Z!@#$%^' < /dev/urandom | fold -w${1-32} | head -n1)
echo $pass > /root/.userpassword
chmod 400 /root/.userpassword

for user in robert david alice charlie edgar frank
do
    ansible-playbook -ilocalhost, --flush-cache --extra-vars "user=$user pass=$pass" add-user.yaml
done

# install the jobs the users will run-yum-update
export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python
ansible-playbook -ilocalhost, --flush-cache install-apps.yaml

