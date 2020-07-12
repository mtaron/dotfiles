#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


ln -s ${BASEDIR}/zshrc ~/.zshrc

ln -s ${BASEDIR}/p10k.zsh ~/.p10k.zsh

ln -s ${BASEDIR}/profile ~/.profile