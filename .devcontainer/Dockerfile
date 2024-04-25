FROM docker.io/ubuntu:jammy

RUN DEBIAN_FRONTEND=noninteractive apt-get update --yes \
    && apt-get upgrade --yes \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        dialog \
        git \
        gnupg2 \
        init-system-helpers \
        less \
        locales \
        openssh-client \
        sudo \
        tzdata \
        unzip \
        xclip \
        zip \
        zsh \
    && yes | unminimize 2>&1 \
    && rm --recursive --force /var/lib/apt/lists/* \
    && locale-gen "en_US.UTF-8" \
    && dpkg-reconfigure locales

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --shell /usr/bin/zsh --uid $USER_UID --gid $USERNAME --create-home $USERNAME \
    # Add sudo support
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

CMD [ "sleep", "infinity" ]
