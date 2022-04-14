# Update OS dependencies
alias up='sudo apt update && sudo apt -V --yes upgrade'

# Remove untracked files and directories
alias clean='git clean --force -X -d'

alias cf='aws cloudformation'

alias c='code .'

alias k='kubectl'
alias kl='kubectl logs --follow'

alias dotfiles='code $XDG_DATA_HOME/chezmoi'

alias activate='source .venv/bin/activate'
