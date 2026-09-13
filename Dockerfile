FROM ubuntu:latest

RUN apt-get update && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    git \
    git-lfs \
    shellcheck \
    sudo \
    xclip \
    zsh \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=bind,target=/build /build/install.sh

ENTRYPOINT [ "zsh" ]
