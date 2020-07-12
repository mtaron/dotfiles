#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp --remove-destination ${BASEDIR}/p10k.zsh ~/.p10k.zsh

cp --remove-destination ${BASEDIR}/zshenv ~/.zshenv

cp --remove-destination ${BASEDIR}/zshrc ~/.zshrc

rm -rf ${BASEDIR}