#!/bin/bash

# https://stackoverflow.com/questions/11685135/how-to-get-parent-folder-of-executing-script-in-zsh
script_dir=$(dirname "${BASH_SOURCE:-$0}")

if [ ! -d "$HOME/zgenom" ]; then
  git clone https://github.com/jandamm/zgenom.git "$HOME/zgenom"
fi

mkdir -p "$HOME/.zshrc.d"

stow zshrc     --dir "$script_dir" --target "$HOME"
stow p10k      --dir "$script_dir" --target "$HOME"

rm -rf "$HOME/.zgenom"
source "$HOME/.zshrc"