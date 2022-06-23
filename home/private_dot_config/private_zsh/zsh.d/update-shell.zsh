reset-shell()
{
    has chezmoi && chezmoi apply
    zgenom reset
    exec zsh
}

update-shell()
{
    zgenom update
    has chezmoi && chezmoi update
    exec zsh
}
