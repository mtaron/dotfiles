dotfiles-reset()
{
    chezmoi apply
    zgenom reset
    exec zsh
}

dotfiles-update()
{
    chezmoi update
    zgenom update
    exec zsh
}
