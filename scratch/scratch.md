# Scratch

## Manual Setup

### Manual Grub Setup for NVidia and to skip dual boot prompt
In /etc/default/grub

```
GRUB_CMDLINE_LINUX="nvidia-drm.modeset=1"
GRUB_DISABLE_OS_PROBER=true
```

### Amazing how hard this is in bash, zsh, and sh...
Get a script's current directory in zsh
`"${${(%):-%x}:a:h}"`

### Need to learn more about backing up gpg keys, maybe using yubikey
https://www.jwillikers.com/backup-and-restore-a-gpg-key

> Use `gh auth login --scopes=read:packages` in order to pull packages from GHCR.

### Other dotfiles to look at
https://github.com/jmdaemon/chezmoi
https://github.com/neersighted/dotfiles

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


## Todo

```
curl -fsSL <key url> \
| sudo gpg --dearmor --output /etc/apt/keyrings/<name>.gpg
```

Brave:
```
curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
| sudo gpg --dearmor --output /etc/apt/keyrings/brave-browser.gpg
```

GitHub:
```
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
| sudo gpg --dearmor --output /etc/apt/keyrings/githubcli.gpg
```

Kubectl:
```
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key \
| sudo gpg --dearmor --output /etc/apt/keyrings/kubernetes.gpg
```

1Password:
https://support.1password.com/install-linux/#debian-or-ubuntu
```
curl -fsSL https://downloads.1password.com/linux/keys/1password.asc \
| sudo gpg --dearmor --output /etc/apt/keyrings/1password.gpg
```

Add sources:

Brave:
https://brave.com/linux/#debian-ubuntu-mint
```
echo 'deb [signed-by=/etc/apt/keyrings/brave-browser.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main' \
| sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
```

GitHub:
https://github.com/cli/cli/blob/trunk/docs/install_linux.md
```
echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/githubcli.gpg] https://cli.github.com/packages stable main' \
| sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
```

Kubectl:
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management
```
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' \
| sudo tee /etc/apt/sources.list.d/kubernetes.list  > /dev/null
```

1Password:
https://support.1password.com/install-linux/#debian-or-ubuntu
```
echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/1password.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' \
| sudo tee /etc/apt/sources.list.d/1password.list > /dev/null
```

```
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
```

Docker
https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

```
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

```
sudo apt install git git-lfs jq kubectl ripgrep shellcheck gh brave-browser 1password  1password-cli

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo apt install bat direnv fzf unzip xclip

