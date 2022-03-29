# Reload the shell configuration
alias zshrc="source $HOME/.zshrc"

# Update OS dependencies
alias up='sudo apt update && sudo apt -V --yes upgrade'

# Remove untracked files and directories
alias clean='git clean --force -X -d'

alias cf='aws cloudformation'
