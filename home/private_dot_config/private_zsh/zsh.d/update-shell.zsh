reset-shell()
{
    chezmoi apply
    zgenom reset
    zsh
}

update-shell()
{
    zgenom update
    chezmoi update
    zsh
}
