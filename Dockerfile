FROM ubuntu:latest

RUN apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    git \
    git-lfs \
    sudo \
    wl-clipboard \
    zsh \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=bind,target=/dotfiles /dotfiles/install.sh

ENTRYPOINT [ "zsh" ]
