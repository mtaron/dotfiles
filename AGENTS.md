# Project

This project is personal dotfiles managed by [chezmoi](https://www.chezmoi.io/) for an Ubuntu 26.04 x64 machine.

# Development and testing

Changes to `*.tmpl` template files can be validated using `chezmoi execute-template < <file_name>.tmpl`.
`*.sh.tmpl` files can be further validated by piping the result to shellcheck, e.g. `chezmoi execute-template < home/.chezmoiscripts/ubuntu/run_onchange_before_zoom.sh.tmpl | shellcheck --external-sources -`

To test end to end, run `docker build --tag dotfiles --progress plain .` and `docker run -it --rm dotfiles`. A command like `l $ZDOTDIR` run inside the container validates that aliases and environment variables are set.

