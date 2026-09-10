#!/usr/bin/env bash
#
# System setup prior to chezmoi

set -euo pipefail

readonly APT_KEYRING=/etc/apt/keyrings

# Installs system packages that are used by the rest of this script and other dotfiles
install_prerequisites() {
  sudo apt-get update
  sudo apt-get install --yes --no-install-recommends \
    bat \
    curl \
    fonts-cascadia-code \
    ghostty \
    git \
    git-lfs \
    gnupg \
    jq \
    ripgrep \
    shellcheck \
    xclip \
    zsh
}

# add_apt_key URL KEY_PATH
add_apt_key() {
  local url=$1 key_path=$2
  [[ -f "$key_path" ]] && return 0
  curl -fsSL "$url" | sudo gpg --dearmor --output "$key_path"
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
  local key_path="$APT_KEYRING/microsoft.gpg"
  add_apt_key https://packages.microsoft.com/keys/microsoft.asc "$key_path"
  add_apt_source vscode.sources https://packages.microsoft.com/repos/code "$key_path"
}

# https://support.1password.com/install-linux/#debian-or-ubuntu
add_apt_source_1password() {
  local key_path="$APT_KEYRING/1password.gpg"
  add_apt_key https://downloads.1password.com/linux/keys/1password.asc "$key_path"
  add_apt_source 1password.sources "https://downloads.1password.com/linux/debian/$architecture" "$key_path"

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

  # Manual steps after install:
  # - sign into 1Password, Settings > Developer > "Integrate with 1Password CLI"
  # - validate by running "op vault list"
}

# https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian
add_apt_source_github() {
  local key_path="$APT_KEYRING/githubcli.gpg"
  add_apt_key https://cli.github.com/packages/githubcli-archive-keyring.gpg "$key_path"
  add_apt_source github-cli.sources https://cli.github.com/packages "$key_path"

  # Manual steps after install:
  # - gh auth login
}

# https://brave.com/linux/#debian-ubuntu-mint
add_apt_source_brave() {
  local key_path="$APT_KEYRING/brave-browser.gpg"
  add_apt_key https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg "$key_path"
  add_apt_source brave-browser.sources https://brave-browser-apt-release.s3.brave.com/ "$key_path"
}

# https://code.claude.com/docs/en/desktop-linux#install
add_apt_source_claude_desktop() {
  local key_path="$APT_KEYRING/claude-desktop.gpg"
  add_apt_key https://downloads.claude.ai/claude-desktop/key.asc "$key_path"
  add_apt_source claude-desktop.sources https://downloads.claude.ai/claude-desktop/apt/stable "$key_path"
}

# https://code.claude.com/docs/en/setup#install-with-linux-package-managers
add_apt_source_claude_code() {
  local key_path="$APT_KEYRING/claude-code.gpg"
  add_apt_key https://downloads.claude.ai/keys/claude-code.asc "$key_path"
  add_apt_source claude-code.sources https://downloads.claude.ai/claude-code/apt/stable "$key_path"
}

add_apt_sources() {
  architecture=$(dpkg --print-architecture)
  readonly architecture

  add_apt_source_vscode
  add_apt_source_1password
  add_apt_source_github
  add_apt_source_brave
  add_apt_source_claude_desktop
  add_apt_source_claude_code
}

# Installs the packages that are available from the apt sources added above.
install_packages() {
  sudo apt-get update
  sudo apt-get install --yes --no-install-recommends \
    1password \
    1password-cli \
    brave-browser \
    claude-code \
    claude-desktop \
    code \
    gh
}

configure_systemd() {
  # https://ghostty.org/docs/linux/systemd#starting-ghostty-at-login
  systemctl enable --user app-com.mitchellh.ghostty.service
}

configure_shell() {
  local zsh_path
  zsh_path=$(command -v zsh)
  if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh --shell "$zsh_path"
  fi
}

main() {
  install_prerequisites

  add_apt_sources
  install_packages

  configure_systemd
  configure_shell
}

main "$@"
