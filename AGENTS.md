# Project

This project is personal dotfiles managed by [chezmoi](https://www.chezmoi.io/) for an Ubuntu 26.04 x64 machine.

# Development and testing

Changes to `*.tmpl` template files can be validated using `chezmoi execute-template < <file_name>.tmpl`.
`*.sh.tmpl` files can be further validated by piping the result to shellcheck, e.g. `chezmoi execute-template < home/.chezmoiscripts/ubuntu/run_onchange_after_zoom.sh.tmpl | shellcheck --external-sources -`

To test end to end, run `docker build --tag dotfiles --progress plain .` and `docker run -it --rm dotfiles`. A command like `l $ZDOTDIR` run inside the container validates that aliases and environment variables are set.

# Adding or upading a tool
Most tools are managed using [mise](https://mise.jdx.dev/dev-tools/). The configuration file is at `home/private_dot_config/mise/config.toml`.
Use `update-mise-lock` function to update the checked in lock file.

Some tools (including mise itself) are locked using `home/.chezmoidata/externals.yaml`. These pins are updated using `scripts/update.zsh`.

When adding a new tool, add a completion file to the `home/private_dot_config/private_zsh/exact_completions` directory. Additionally, these dotfiles attempt to follow the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/). If needed, add environment variables to configure the tool to follow the XDG spec to `home/private_dot_zshenv.tmpl`, e.g. `export KUBERC="$XDG_CONFIG_HOME/kubectl/kuberc"`.
