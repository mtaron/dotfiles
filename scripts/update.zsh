#!/usr/bin/env zsh
setopt ERR_EXIT PIPE_FAIL

externals=${0:A:h:h}/home/.chezmoidata/externals.yaml

# update-github-commit NAME REPO BRANCH
# Pins NAME to the latest commit on BRANCH, without a checksum.
update-github-commit() {
  local name=$1 repo=$2 branch=$3
  version=$(gh api repos/$repo/commits/$branch --jq .sha)
  version=$version yq -i ".externals.$name.version = strenv(version)" $externals
}

# update-github-archive NAME REPO BRANCH
# Pins NAME to the latest commit on BRANCH along with the checksum of its archive.
update-github-archive() {
  local name=$1 repo=$2 branch=$3
  update-github-commit $name $repo $branch
  sha256=$(curl -fsSL https://github.com/$repo/archive/$version.tar.gz | sha256sum | cut -d' ' -f1)
  sha256=$sha256 yq -i ".externals.$name.sha256 = strenv(sha256)" $externals
}

update-mise() {
  release=$(gh release view --repo jdx/mise --json tagName,assets) yq -i '
    env(release) as $r
    | .externals.mise.version = $r.tagName
    | .externals.mise.sha256 = ($r.assets[] | select(.name == "mise-" + $r.tagName + "-linux-x64") | .digest | sub("sha256:", ""))
    | .externals.mise.completions_sha256 = ($r.assets[] | select(.name == "mise.zsh") | .digest | sub("sha256:", ""))
  ' $externals
}

chezmoi upgrade
update-github-archive zgenom jandamm/zgenom main
update-github-archive ohmyzsh ohmyzsh/ohmyzsh master
update-github-commit zsh_shift_select jirutka/zsh-shift-select master
update-github-commit zsh_autopair hlissner/zsh-autopair master
update-github-commit zgenom_ext_eval jandamm/zgenom-ext-eval main
update-mise
