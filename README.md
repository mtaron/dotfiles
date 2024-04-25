# dotfiles

```
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply mtaron
```

Tools used:
- Dotfile manager: [chezmoi](https://www.chezmoi.io/)
- ZSH plugin manager: [zgenom](https://github.com/jandamm/zgenom)

Development note: In order to push changes that effect ci.yaml, the GitHub CLI needs "workflow" scope, e.g. `gh auth login --scopes 'read:packages workflow'`
