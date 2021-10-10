# Reload the shell configuration
alias zshrc="source $HOME/.zshrc"

# Update OS dependencies
alias up='sudo apt update && sudo apt -V --yes upgrade'

# Defined in functions.zsh
alias ut='update-tools'

# Remove untracked files and directories
alias clean='git clean --force -X -d'
