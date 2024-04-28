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
