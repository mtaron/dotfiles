# Scratch

## Manual Setup

### Manual Grub Setup for NVidia and to skip dual boot prompt
In /etc/default/grub

```
GRUB_CMDLINE_LINUX="nvidia-drm.modeset=1"
GRUB_DISABLE_OS_PROBER=true
```

### Manual snapd removal
Uninstall snap: https://fedingo.com/how-to-remove-snap-in-ubuntu/
Also remove from PATH in /etc/environment

### Need to learn more about backing up gpg keys, maybe using yubikey
https://www.jwillikers.com/backup-and-restore-a-gpg-key

### Figure out how to turn off dock too...
Turn off desktop icons: `gnome-extensions disable ding@rastersoft.com`

### Some auto installed things that can be removed
sudo apt remove yelp eog evince app-install-data-partner

## Todo

### There is probably a way to save and apply all gnome settings...
Load gnome terminal settings
`dconf load -f /org/gnome/terminal/ < gnome-terminal.dconf`

Dump settings:
`dconf dump /org/gnome/terminal/ > gnome-terminal.dconf`

### Useful for setting up keybindings
Shows terminal code for key combinations
`showkey -a`

### Amazing how hard this is in bash, zsh, and sh...
Get a script's current directory in zsh
`"${${(%):-%x}:a:h}"`

### Other dotfiles to look at
https://github.com/jmdaemon/chezmoi
https://github.com/neersighted/dotfiles

### Need to set up podman
set DOCKER_HOST to podman
`export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock`

### System Packages
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt update
sudo apt install gh

bat
direnv
exa
fd-find
fzf
git
git-lfs
jq
ripgrep
shellcheck
unzip
xclip
fonts-ibm-plex
fonts-cascadia-code
