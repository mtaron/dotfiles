#!/usr/bin/env bash
#
# System setup prior to chezmoi

set -euo pipefail

# Installs system packages that are used by the rest of this script and other dotfiles
install_prerequisites() {
  sudo apt-get update
  sudo apt-get install --yes --no-install-recommends \
    cuda-toolkit \
    curl \
    fonts-cascadia-code \
    git \
    git-lfs \
    gnupg \
    terminfo \
    util-linux-extra \
    wl-clipboard \
    zsh
}

script_dir="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
apt_dir="$script_dir/apt"

install_apt_sources() {
  sudo install --mode 0644 "$apt_dir"/keys/* /etc/apt/keyrings/
  sudo install --mode 0644 "$apt_dir"/sources/* /etc/apt/sources.list.d/
}

# https://support.1password.com/install-linux/#debian-or-ubuntu
# 1Password additionally verifies its .deb signature via debsig-verify.
install_1password_debsig() {
  local id=AC2D62742012EA22
  sudo install --directory --mode 0755 "/etc/debsig/policies/$id"
  sudo install --mode 0644 "$apt_dir/debsig/1password.pol" \
    "/etc/debsig/policies/$id/1password.pol"

  sudo install --directory --mode 0755 "/usr/share/debsig/keyrings/$id"
  sudo install --mode 0644 "$apt_dir/keys/1password.asc" \
    "/usr/share/debsig/keyrings/$id/debsig.gpg"
}

# https://code.claude.com/docs/en/desktop-linux#install
# Stop the package from re-adding its own apt source on upgrade.
configure_claude_desktop() {
  sudo tee /etc/default/claude-desktop <<< "CLAUDE_DESKTOP_ADD_REPO=false" >/dev/null
}

add_apt_sources() {
  # for alacritty https://launchpad.net/~aslatter/+archive/ubuntu/ppa
  if ! sudo add-apt-repository --list | grep -q "https://ppa.launchpadcontent.net/aslatter/ppa/ubuntu/"; then
    sudo add-apt-repository --no-update --yes ppa:aslatter/ppa
  fi

  install_apt_sources
  install_1password_debsig
  configure_claude_desktop
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
    gh \
    nvidia-container-toolkit
}

post_install() {
  # https://docs.docker.com/engine/install/linux-postinstall/
  sudo usermod --append --groups docker "$USER"
  newgrp docker

  sudo nvidia-ctk runtime configure --runtime=docker
  sudo systemctl restart docker
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
