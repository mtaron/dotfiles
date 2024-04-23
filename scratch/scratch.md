# Scratch

## Manual Setup

### Manual Grub Setup for NVidia and to skip dual boot prompt
In /etc/default/grub

```
GRUB_CMDLINE_LINUX="nvidia-drm.modeset=1"
GRUB_DISABLE_OS_PROBER=true
```

### Need to learn more about backing up gpg keys, maybe using yubikey
https://www.jwillikers.com/backup-and-restore-a-gpg-key

## Todo

### Useful for setting up keybindings
Shows terminal code for key combinations
`showkey -a`

### Amazing how hard this is in bash, zsh, and sh...
Get a script's current directory in zsh
`"${${(%):-%x}:a:h}"`

### Other dotfiles to look at
https://github.com/jmdaemon/chezmoi
https://github.com/neersighted/dotfiles

### System Packages
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo dd of=/usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt install kubectl

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


> Use `gh auth login --scopes=read:packages` in order to pull packages from GHCR.


https://developer.1password.com/docs/cli/get-started/#install

If you copy a SSH key to another machine, you need to do this:

chmod 600 id_rsa
chmod 644 id_rsa.pub

https://stackoverflow.com/a/51564078


Certs:
https://www.ibm.com/docs/en/hpvs/1.2.x?topic=reference-openssl-configuration-examples
https://betterprogramming.pub/how-to-create-trusted-ssl-certificates-for-your-local-development-13fd5aad29c6
https://www.richud.com/wiki/Ubuntu_chrome_browser_import_self_signed_certificat
https://www.openssl.org/docs/man1.0.2/man5/x509v3_config.html <- name constraints
