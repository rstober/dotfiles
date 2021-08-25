#!/usr/bin/env bash

set -x
set -v

echo "this is the install script"

installdir=/root/.road-runner

if [ ! -d $installdir ]; then
    mkdir -p $installdir
fi

cd $installdir

wget https://raw.githubusercontent.com/rstober/dotfiles/main/cmshrc .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/bookmarks-cmsh .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/du.cmsh .
wget https://raw.githubusercontent.com/rstober/dotfiles/main/si.cmsh .

cp cmshrc /root/.cmshrc
cp bookmarks-cmsh /root/.bookmarks-cmsh
cp du.cmsh /root/.cm/cmsh/du.cmsh
cp si.cmsh /root/.cm/cmsh/si.cmsh

module load python3

pip install ansible-base

export ANSIBLE_PYTHON_INTERPRETER=/cm/local/apps/python3/bin/python

ansible-galaxy collection install brightcomputing.bcm