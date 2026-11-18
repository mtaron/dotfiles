# terragrunt has no zsh completion script; it answers bash-style `complete -C` queries.
autoload -Uz bashcompinit && bashcompinit
complete -C terragrunt terragrunt
