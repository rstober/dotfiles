#!/usr/bin/env bash -xv

echo "this is the install script"

installdir=/root/.road-runner

if [ ! -d $installdir ]; then
    mkdir -p $installdir
fi

#cd $installdir

wget https://raw.githubusercontent.com/rstober/dotfiles/main/cmshrc $installdir