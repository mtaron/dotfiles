# dotfiles

## Prequesites
- [Cascadia Code](https://github.com/microsoft/cascadia-code/wiki/Installing-Cascadia-Code) font
- stow `sudo apt install stow`
- fzf `sudo apt install fzf`

## Usage
```
git clone https://github.com/mtaron/dotfiles.git "$HOME/dotfiles"
zsh "$HOME/dotfiles/install.zsh"
```

## References
- [Using GNU Stow to manage your dotfiles](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
- [Toms Quest dotfiles](https://github.com/tomsquest/dotfiles)
- [zsh quickstart](https://github.com/unixorn/zsh-quickstart-kit#fzf)


## Github CLI
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