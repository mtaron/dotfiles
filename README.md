# dotfiles

```
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply mtaron
```

Use `docker run --rm -it $(docker build -q .)` to test dotfile install on a fresh environment.
