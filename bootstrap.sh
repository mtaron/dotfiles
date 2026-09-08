#!/usr/bin/env bash
#
# System setup prior to chezmoi

set -euo pipefail

readonly APT_KEYRING=/etc/apt/keyrings
readonly APT_SOURCES_DIR=/etc/apt/sources.list.d

# Installs system packages that are used by the rest of this script and other dotfiles
install_prerequisites() {
    sudo apt-get update
    sudo apt-get install --yes \
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

install_prerequisites

# Add apt sources

architecture=$(dpkg --print-architecture)

# Adds an apt key if it doesn't already exist.
# Argument 1: URL to the key
# Argument 2: Path to the keyring file
add_apt_key() {
  [[ ! -f "$2" ]] && curl -fsSL "$1" | sudo gpg --dearmor --output "$2" || true
}

# Adds an apt source if it doesn't already exist.
# Argument 1: Name of the source file (e.g. "vscode.sources")
add_apt_source() {
  local sources_path="$APT_SOURCES_DIR/$1"
  [[ ! -f "$sources_path" ]] && sudo tee "$sources_path" >/dev/null || true
}

# https://code.visualstudio.com/docs/setup/linux
add_apt_source_vscode() {
  local key_path="$APT_KEYRING/microsoft.gpg"
  add_apt_key https://packages.microsoft.com/keys/microsoft.asc "$key_path"

  add_apt_source vscode.sources <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: $architecture
Signed-By: $key_path
EOF
}

# https://support.1password.com/install-linux/#debian-or-ubuntu
add_apt_source_1password() {
  local key_path="$APT_KEYRING/1password.gpg"
  add_apt_key https://downloads.1password.com/linux/keys/1password.asc "$key_path"

  add_apt_source 1password.sources <<EOF
Types: deb
URIs: https://downloads.1password.com/linux/debian/$architecture
Suites: stable
Components: main
Architectures: $architecture
Signed-By: $key_path
EOF

  # Add the debsig-verify policy
  local policy_path=/etc/debsig/policies/AC2D62742012EA22/1password.pol
  if [[ ! -f "$policy_path" ]]; then
    sudo mkdir -p "$(dirname "$policy_path")"
    curl -fsSL https://downloads.1password.com/linux/debian/debsig/1password.pol \
      | sudo tee "$policy_path" >/dev/null
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

  add_apt_source github-cli.sources <<EOF
Types: deb
URIs: https://cli.github.com/packages
Suites: stable
Components: main
Architectures: $architecture
Signed-By: $key_path
EOF

  # Manual steps after install:
  # - gh auth login
}

# https://brave.com/linux/#debian-ubuntu-mint
add_apt_source_brave() {
  local key_path="$APT_KEYRING/brave-browser.gpg"
  add_apt_key https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg "$key_path"

  add_apt_source brave-browser.sources <<EOF
Types: deb
URIs: https://brave-browser-apt-release.s3.brave.com/
Suites: stable
Components: main
Architectures: $architecture
Signed-By: $key_path
EOF
}

add_apt_source_vscode
add_apt_source_1password
add_apt_source_github
add_apt_source_brave

# Install the packages that are available from the apt sources we just added
sudo apt-get update
sudo apt-get install --yes \
  1password \
  1password-cli \
  brave-browser \
  code \
  gh

# systemd configuration

# https://ghostty.org/docs/linux/systemd#starting-ghostty-at-login
systemctl enable --user app-com.mitchellh.ghostty.service

chsh --shell "$(command -v zsh)"
