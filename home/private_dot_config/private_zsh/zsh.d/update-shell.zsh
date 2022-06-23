reset-shell()
{
    chezmoi apply
    zgenom reset
    exec zsh
}

update-shell()
{
    zgenom update
    chezmoi update
    exec zsh
}
