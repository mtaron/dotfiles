#!/bin/zsh

dir_path=$(dirname "$(realpath "$0")")

update-pip()
{
    # Clear custom pip.conf which has short term access tokens to AWS feeds
    rm --force "$HOME/.config/pip/pip.conf"

    echo "$fg[green] Updating pip$reset_color"
    python -m pip install --upgrade pip

    echo "$fg[green] Updating pipx$reset_color"
    python -m pip install --user --upgrade pipx

    echo "$fg[green] Updating pipx packages$reset_color"
    pipx upgrade-all
}

install-pipx-tools()
{
    pipx install flake8
    pipx install black
    pipx install cfn-lint
}

update-node()
{
    echo "$fg[green] Updating pnpm$reset_color"
    source "$dir_path/install-pnpm.sh"
}

update-aws()
{
    echo "$fg[green] Updating AWS CLI (requires elevation)$reset_color"
    source "$dir_path/update-aws-cli.sh"
}

update-tools()
{
    echo "$fg[green] Updating zgenom$reset_color"
    zgenom selfupdate

    echo "$fg[green] Updating zsh plugins$reset_color"
    zgenom update

    update-pip

    update-nvm

    update-aws

    zgenom reset

    source "$HOME/.zshrc"
}
