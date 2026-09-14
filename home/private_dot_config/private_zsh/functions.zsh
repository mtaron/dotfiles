docker-size()
{
    docker manifest inspect $1 | jq -r '.config.size + ([.layers[].size] | add)' | numfmt --to=iec
}

update_mise_lock() {
  chezmoi apply
  mise lock --global --bump
  chezmoi add "$XDG_CONFIG_HOME/mise/mise.lock"
  chezmoi apply
}
