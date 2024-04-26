#!/usr/bin/env sh

set -e

zsh_path="$(command -v zsh)"
if [ "$SHELL" != "$zsh_path" ]; then
    echo "▶️ changing default shell to zsh"
    sudo chsh --shell "$zsh_path"
fi
