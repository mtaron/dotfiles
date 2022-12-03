#!/usr/bin/env sh

set -e

zsh_path="$(command -v zsh)"
if [ "$zsh_path" ] && [ "$SHELL" != "$zsh_path" ]; then
    echo "Changing default shell to zsh"
    sudo chsh --shell "$zsh_path"
fi
