#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp --remove-destination ${BASEDIR}/p10k.zsh ~/.p10k.zsh

cp --remove-destination ${BASEDIR}/zshenv ~/.zshenv

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc

rm -rf ${BASEDIR}