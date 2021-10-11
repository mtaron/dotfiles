#!/bin/sh

# https://pnpm.io/installation
# Source: https://get.pnpm.io/install.sh

# From https://github.com/Homebrew/install/blob/master/install.sh
abort() {
  printf "%s\n" "$@"
  exit 1
}

# string formatters
if [ -t 1 ]; then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi
tty_mkbold() { tty_escape "1;$1"; }
tty_blue="$(tty_mkbold 34)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

ohai() {
  printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$1"
}

# End from https://github.com/Homebrew/install/blob/master/install.sh

download() {
  if command -v curl > /dev/null 2>&1; then
    curl -fsSL "$1"
  else
    wget -qO- "$1"
  fi
}

detect_platform() {
  local platform
  platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

  case "${platform}" in
    linux) platform="linux" ;;
    darwin) platform="macos" ;;
    windows) platform="win" ;;
  esac

  printf '%s' "${platform}"
}

detect_arch() {
  local arch
  arch="$(uname -m | tr '[:upper:]' '[:lower:]')"

  case "${arch}" in
    x86_64) arch="x64" ;;
    amd64) arch="x64" ;;
    armv*) arch="arm" ;;
    arm64 | aarch64) arch="arm64" ;;
  esac

  # `uname -m` in some cases mis-reports 32-bit OS as 64-bit, so double check
  if [ "${arch}" = "x64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
    arch=i686
  elif [ "${arch}" = "arm64" ] && [ "$(getconf LONG_BIT)" -eq 32 ]; then
    arch=arm
  fi

  case "$arch" in
    x64*) ;;
    arm64*) ;;
    *) return 1
  esac
  printf '%s' "${arch}"
}

platform="$(detect_platform)"
arch="$(detect_arch)" || abort "Sorry! pnpm currently only provides pre-built binaries for x86_64/arm64 architectures."
pkgName="@pnpm/${platform}-${arch}"
version_json="$(download "https://registry.npmjs.org/${pkgName}")" || abort "Download Error!"
version="$(printf '%s' "${version_json}" | tr '{' '\n' | awk -F '"' '/latest/ { print $4 }')"
archive_url="https://registry.npmjs.org/${pkgName}/-/${platform}-${arch}-${version}.tgz"

download_and_install() {
  local archive_url="$1"
  local tmp_dir="$2"

  ohai 'Extracting pnpm binaries'
  # extract the files to the specified directory
  download "$archive_url" | tar -xz -C "$tmp_dir" --strip-components=1 || return 1
  SHELL="$SHELL" "$tmp_dir/pnpm" setup || return 1
}

# install to PNPM_HOME, defaulting to ~/.pnpm
tmp_dir="$(mktemp -d)" || abort "Tmpdir Error!"
trap 'rm -rf "$tmp_dir"' EXIT INT TERM HUP

download_and_install "$archive_url" "$tmp_dir" || abort "Install Error!"
