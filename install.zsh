#!/bin/zsh

# https://stackoverflow.com/questions/11685135/how-to-get-parent-folder-of-executing-script-in-zsh
script_dir=${BASH_SOURCE:-$0}

git clone https://github.com/jandamm/zgenom.git "$HOME/zgenom"

cd $script_dir

stow zshrc
stow p10k

source "$HOME/"