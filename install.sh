#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


cp --remove-destination ${BASEDIR}/zshrc ~/.zshrc

cp --remove-destination ${BASEDIR}/p10k.zsh ~/.p10k.zsh

cp --remove-destination ${BASEDIR}/profile ~/.profile

rm -rf ${BASEDIR}