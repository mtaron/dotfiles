#!/usr/bin/env zsh

update-mise-lock() {
  chezmoi apply
  mise lock --global --bump
  chezmoi add "$XDG_CONFIG_HOME/mise/mise.lock"
  chezmoi apply
}

fetch-github-checksum() {
  local repo=${1:?Usage: fetch-github-checksum <owner/repo> [branch]}
  local branch=${2:-main}
  local hash=$(gh api repos/$repo/commits/$branch --jq .sha)
  local checksum=$(curl -sL "https://github.com/$repo/archive/$hash.tar.gz" | sha256sum | cut -d' ' -f1)
  jq -n --arg repo "$repo" --arg hash "$hash" --arg checksum "$checksum" \
    '{repo: $repo, hash: $hash, checksum: $checksum}'
}

fetch-mise-release() {
  local data=$(gh release view --repo jdx/mise --json assets,tagName)
  local version=$(jq -r .tagName <<< "$data")
  local mise_checksum=$(jq -r '.assets[] | select(.name == "mise-'$version'-linux-x64") | .digest' <<< "$data" | cut -d: -f2)
  local completions_checksum=$(jq -r '.assets[] | select(.name == "mise.zsh") | .digest' <<< "$data" | cut -d: -f2)
  jq -n --arg version "$version" --arg mise "$mise_checksum" --arg completions "$completions_checksum" \
    '{repo: "jdx/mise", version: $version, mise_checksum: $mise, completions_checksum: $completions}'
}

fetch-pinned-externals() {
  setopt LOCAL_OPTIONS NO_MONITOR
  fetch-github-checksum ohmyzsh/ohmyzsh master &
  fetch-github-checksum jandamm/zgenom &
  fetch-mise-release &
  wait
}
