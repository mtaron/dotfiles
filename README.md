# dotfiles

## Inspiration
- https://github.com/neersighted/dotfiles


## Scratch

### Github CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt update
sudo apt install gh

Instead of snap
https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64

In /etc/default/grub

```
GRUB_CMDLINE_LINUX="nvidia-drm.modeset=1"
GRUB_DISABLE_OS_PROBER=true
```

https://www.jwillikers.com/backup-and-restore-a-gpg-key

Load gnome terminal settings
`dconf load -f /org/gnome/terminal/ < gnome-terminal.dconf`

Dump settings:
`dconf dump /org/gnome/terminal/ > gnome-terminal.dconf`

Uninstall snap: https://fedingo.com/how-to-remove-snap-in-ubuntu/
Also remove from PATH in /etc/environment

Shows terminal code for key combinations
`showkey -a`


https://github.com/baskerville/sxhkd

https://github.com/cblessing24/dotfiles
https://github.com/cblessing24/dotfiles/blob/main/dotfiles/zshenv/.zshenv

https://github.com/dlukes/dotfiles
https://github.com/Krafi2/dotfiles/blob/3d73d64dde69b229be708673661ce01a7ec28ed8/apps/librewolf/app/config/fontconfig/fonts.conf

Simple:
https://github.com/Fubukimaru/archlinux-stuff/blob/08d688e92d8af603fd065445f5831a26a1ab0c13/dotfiles/fontconfig/.config/fontconfig/fonts.conf

https://help.ubuntu.com/community/EnvironmentVariables
https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html


Get scripts current directory in zsh
`"${${(%):-%x}:a:h}"`


https://github.com/janmaghuyop/provision/blob/5fa458c66ef24e97d7a2986bf069cd52ea473d6a/playbook.yml

Turn off desktop icons: `gnome-extensions disable ding@rastersoft.com`

sudo apt remove yelp eog evince app-install-data-partner

Enable automatic login
https://help.gnome.org/admin/system-admin-guide/stable/login-automatic.html.en

Added
- xclip
- shellcheck
- ripgrep
- podman
- jq
- bat


https://github.com/jmdaemon/chezmoi
https://github.com/torjacob/dotfiles/tree/master/zsh

# set DOCKER_HOST to podman
export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock
