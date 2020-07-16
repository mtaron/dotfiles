#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoswitch_virtualenv

cp --remove-destination ${BASEDIR}/p10k.zsh ~/.p10k.zsh

cp --remove-destination ${BASEDIR}/zshenv ~/.zshenv

cp --remove-destination ${BASEDIR}/zshrc ~/.zshrc

rm -rf ${BASEDIR}