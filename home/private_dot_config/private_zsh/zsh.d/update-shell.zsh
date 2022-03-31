update-shell()
{
    chezmoi apply
    zgenom reset
    source "$ZDOTDIR/.zshrc"
}
