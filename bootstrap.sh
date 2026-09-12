#!/usr/bin/env bash
#
# System setup prior to chezmoi

set -euo pipefail

# Installs system packages that are used by the rest of this script and other dotfiles
install_prerequisites() {
  sudo apt-get update
  sudo apt-get install --yes --no-install-recommends \
    curl \
    fonts-cascadia-code \
    git \
    git-lfs \
    gnupg \
    jq \
    ripgrep \
    shellcheck \
    util-linux-extra \
    xclip \
    zsh
}

# add_apt_key URL [NAME]
add_apt_key() {
  local url=$1
  local name=${2:-$(basename "$url")}
  sudo curl --silent --skip-existing --show-error --fail --location \
    --output-dir /etc/apt/keyrings --output "$name" \
    --write-out "%{filename_effective}" "$url"
}

# add_apt_source NAME URL KEY_PATH [SUITE] [COMPONENTS]
add_apt_source() {
  local name=$1 url=$2 key_path=$3
  local suite=${4:-stable} components=${5:-main}
  local sources_path="/etc/apt/sources.list.d/$name"
  [[ -f "$sources_path" ]] && return 0
  sudo tee "$sources_path" >/dev/null <<EOF
Types: deb
URIs: $url
Suites: $suite
Components: $components
Architectures: $architecture
Signed-By: $key_path
EOF
}

# https://code.visualstudio.com/docs/setup/linux
add_apt_source_vscode() {
  add_apt_source vscode.sources \
    https://packages.microsoft.com/repos/code \
    "$(add_apt_key https://packages.microsoft.com/keys/microsoft.asc)"
}

# https://support.1password.com/install-linux/#debian-or-ubuntu
add_apt_source_1password() {
  add_apt_source 1password.sources \
    "https://downloads.1password.com/linux/debian/$architecture" \
    "$(add_apt_key https://downloads.1password.com/linux/keys/1password.asc)"

  # Add the debsig-verify policy
  local policy_path=/etc/debsig/policies/AC2D62742012EA22/1password.pol
  if [[ ! -f "$policy_path" ]]; then
    sudo mkdir -p "$(dirname "$policy_path")"
    curl -fsSL https://downloads.1password.com/linux/debian/debsig/1password.pol |
      sudo tee "$policy_path" >/dev/null
  fi

  local debsig_key_path=/usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  if [[ ! -f "$debsig_key_path" ]]; then
    sudo mkdir -p "$(dirname "$debsig_key_path")"
    sudo cp "$key_path" "$debsig_key_path"
  fi
}

# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian
add_apt_source_github() {
  add_apt_source github-cli.sources \
    https://cli.github.com/packages \
    "$(add_apt_key https://cli.github.com/packages/githubcli-archive-keyring.gpg)"
}

# https://brave.com/linux/#debian-ubuntu-mint
add_apt_source_brave() {
  add_apt_source brave-browser.sources \
    https://brave-browser-apt-release.s3.brave.com/ \
    "$(add_apt_key https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg)"
}

# https://code.claude.com/docs/en/desktop-linux#install
add_apt_source_claude_desktop() {
  add_apt_source claude-desktop.sources \
    https://downloads.claude.ai/claude-desktop/apt/stable \
    "$(add_apt_key https://downloads.claude.ai/claude-desktop/key.asc claude-desktop.asc)"

    sudo tee /etc/default/claude-desktop <<< "CLAUDE_DESKTOP_ADD_REPO=false" >/dev/null
}

# https://code.claude.com/docs/en/setup#install-with-linux-package-managers
add_apt_source_claude_code() {
  add_apt_source claude-code.sources \
    https://downloads.claude.ai/claude-code/apt/stable \
    "$(add_apt_key https://downloads.claude.ai/keys/claude-code.asc)"
}

# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
add_apt_source_docker() {
  add_apt_source docker.sources \
    https://download.docker.com/linux/ubuntu \
    "$(add_apt_key https://download.docker.com/linux/ubuntu/gpg docker.asc)" \
    "$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")" \
    "stable"
}

add_apt_sources() {
  architecture=$(dpkg --print-architecture)
  readonly architecture

  # for alacritty https://launchpad.net/~aslatter/+archive/ubuntu/ppa
  if ! sudo add-apt-repository --list | grep -q "https://ppa.launchpadcontent.net/aslatter/ppa/ubuntu/"; then
    sudo add-apt-repository --no-update --yes ppa:aslatter/ppa
  fi

  add_apt_source_vscode
  add_apt_source_1password
  add_apt_source_github
  add_apt_source_brave
  add_apt_source_claude_desktop
  add_apt_source_claude_code
  add_apt_source_docker
}

# Installs the packages that are available from the apt sources added above
install_packages() {
  sudo apt-get update
  sudo apt-get install --yes --no-install-recommends \
    1password \
    1password-cli \
    alacritty \
    brave-browser \
    claude-code \
    claude-desktop \
    code \
    containerd.io \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    gh
}

post_install() {
  # https://docs.docker.com/engine/install/linux-postinstall/
  sudo usermod --append --groups docker "$USER"
  newgrp docker
}

configure_shell() {
  local zsh_path
  zsh_path=$(command -v zsh)
  if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh --shell "$zsh_path"
  fi
}

print_manual_steps() {
  cat <<'EOF'

👋 A few things to finish by hand:

🔐 1Password
  • Sign in using the app and enable Settings > Developer > "Integrate with 1Password CLI"
  • Validate with `op vault list`

🐙 GitHub CLI
  • `gh auth login`

🏠 chezmoi
  • Run `./install.sh` to install chezmoi and apply dotfiles
EOF
}

main() {
  install_prerequisites

  add_apt_sources
  install_packages

  post_install
  configure_shell

  print_manual_steps
}

main "$@"
