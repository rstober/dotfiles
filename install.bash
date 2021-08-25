#!/usr/bin/env bash -xv

echo "this is the install script"

installdir = /root/.road-runner

if ! -d $installdir; then
    mkdir -p /root/road-runner
fi

wget https://raw.githubusercontent.com/rstober/dotfiles/main/cmshrc $installdir