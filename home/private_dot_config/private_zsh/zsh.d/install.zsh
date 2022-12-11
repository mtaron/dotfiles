# Downloads VS Code in Portable Mode
# https://code.visualstudio.com/docs/editor/portable
# This has the advantage of a clean home directory and apt update of code seems hit or miss anyways.
install-vs-code()
{
    code_dir="$XDG_DATA_HOME/vscode"

    # Remove old install
    rm -rf "$code_dir"

    # --transform renames the downloaded folder to 'vscode'
    curl --show-error --silent --fail --location "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64" \
        --header "Accept: application/octet-stream" \
        | tar --extract --ungzip --directory "$XDG_DATA_HOME" --transform s/VSCode-linux-x64/vscode/

    # Create a symbolic link to add code to the path
    ln --symbolic --force "$code_dir/bin/code" "$XDG_BIN_DIR/code"

    # Create a symbolic link for zsh completions
    ln --symbolic --force "$code_dir/resources/completions/zsh/_code" "$ZDOTDIR/completions/_code"

    code --version
}

# https://k3d.io/
install-k3d()
{
    rm --force "$XDG_BIN_DIR"/k3d
    curl --show-error --silent --fail --location "https://github.com/k3d-io/k3d/releases/latest/download/k3d-linux-amd64" \
        --output "$XDG_BIN_DIR"/k3d
    chmod u+x "$XDG_BIN_DIR"/k3d
    k3d --version
}

# https://helm.sh/docs/intro/install/#from-script
install-helm()
{
    HELM_INSTALL_DIR="$XDG_BIN_DIR" get-helm-3 --no-sudo
    helm version
}

# https://github.com/GitCredentialManager/git-credential-manager#download-and-install
install-git-credential-manager()
{
    tmp_dir=$(mktemp --directory)
    gh release download \
        --repo GitCredentialManager/git-credential-manager \
        --pattern 'gcm-linux_amd64.*.deb' \
        --dir "$tmp_dir"
    sudo dpkg --install "$tmp_dir"/gcm-linux_amd64.*.deb
    rm -rf "$tmp_dir"
}

# https://github.com/microsoft/artifacts-credprovider#installation-on-linux-and-mac
install-nuget-credential-provider()
{
    plugin_path="$XDG_DATA_HOME/NuGet/plugins"
    uri="https://github.com/Microsoft/artifacts-credprovider/releases/latest/download/Microsoft.Net6.NuGet.CredentialProvider.tar.gz"

    mkdir --parents "$plugin_path"

    # Remove existing plugin if it's already installed
    rm --recursive --force "$plugin_path"/CredentialProvider.Microsoft

    curl --header "Accept: application/octet-stream" \
        --show-error --silent --fail --location \
        "$uri" | tar --extract --ungzip --strip-components=2 --directory "$plugin_path" "plugins/netcore"
}

# https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-azcopy
install-azcopy()
{
    rm --force "$XDG_BIN_DIR"/azcopy

    curl --header "Accept: application/octet-stream" \
        --show-error --silent --fail --location \
        https://aka.ms/downloadazcopy-v10-linux \
    | tar --extract --ungzip --directory "$XDG_BIN_DIR" --strip-components=1 --wildcards "*/azcopy"
}

# https://github.com/Azure/kubelogin
install-kubelogin()
{
    rm --force "$XDG_BIN_DIR"/kubelogin

    tmp_dir=$(mktemp --directory)
    curl --show-error --silent --fail --location "https://github.com/Azure/kubelogin/releases/latest/download/kubelogin-linux-amd64.zip" \
        --output "$tmp_dir"/kubelogin.zip
    unzip -j -d "$XDG_BIN_DIR" "$tmp_dir"/kubelogin.zip
    rm -rf "$tmp_dir"
}

# https://www.pulumi.com/docs/
install-pulumi()
{
    rm --force "$XDG_BIN_DIR"/pulumi*

    version=$(curl --retry 3 --fail --silent --location "https://www.pulumi.com/latest-version")

    curl --show-error --silent --fail \
        --location "https://github.com/pulumi/pulumi/releases/latest/download/pulumi-v$version-linux-x64.tar.gz" \
        --header "Accept: application/octet-stream" \
        | tar --extract --ungzip --directory "$XDG_BIN_DIR" --strip-components=1
}

# https://taskfile.dev/installation/
install-task()
{
    tmp_dir=$(mktemp --directory)
    curl --show-error --silent --fail --location "https://github.com/go-task/task/releases/latest/download/task_linux_amd64.deb" \
        --output "$tmp_dir"/task_linux_amd64.deb
    sudo dpkg --install "$tmp_dir"/task_linux_amd64.deb
    rm -rf "$tmp_dir"
    task --version
}

# https://pnpm.io/installation
install-pnpm()
{
    rm --force "$XDG_BIN_DIR"/pnpm

    curl --show-error --silent --fail --location "https://github.com/pnpm/pnpm/releases/latest/download/pnpm-linux-x64" \
        --output "$XDG_BIN_DIR"/pnpm
    chmod u+x "$XDG_BIN_DIR"/pnpm

    mkdir --parents "$XDG_DATA_HOME/pnpm"
    pnpm --version
}

# https://support.zoom.us/hc/en-us/articles/204206269-Installing-or-updating-Zoom-on-Linux
install-zoom()
{
    tmp_dir=$(mktemp --directory)
    curl --show-error --silent --fail --location https://zoom.us/client/latest/zoom_amd64.deb --output "$tmp_dir/zoom_amd64.deb"
    sudo apt install "$tmp_dir/zoom_amd64.deb"
    rm -rf "$tmp_dir"
}

# https://github.com/pyenv/pyenv-installer
install-pyenv()
{
    export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

    rm -rf "$PYENV_ROOT"
    curl --show-error --silent --fail --location https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
    ln --symbolic --force "$PYENV_ROOT/bin/pyenv" "$XDG_BIN_DIR/pyenv"
}

# https://learning.postman.com/docs/getting-started/installation-and-updates/#installing-postman-on-linux
install-postman()
{
    postman_dir="$XDG_DATA_HOME/postman"

    # Remove old install
    rm -rf "$postman_dir"

    mkdir "$postman_dir"

    curl --show-error --silent --fail \
        --header "Accept: application/octet-stream" \
        --location https://dl.pstmn.io/download/latest/linux64 \
        | tar --extract --ungzip --directory "$postman_dir" --strip-components=2
}

# https://github.com/FiloSottile/mkcert#linux
install-mkcert()
{
    rm --force "$XDG_BIN_DIR"/mkcert

    # sudo apt install libnss3-tools
    curl --show-error --silent --fail --location "https://dl.filippo.io/mkcert/latest?for=linux/amd64" --output "$XDG_BIN_DIR"/mkcert
    chmod u+x "$XDG_BIN_DIR"/mkcert
    mkcert --version
}

update-tools()
{
    zgenom selfupdate
    has azcopy && install-azcopy
    has chezmoi && chezmoi upgrade
    has helm && install-helm
    has k3d && install-k3d
    has kubelogin && install-kubelogin
    has pulumi && install-pulumi
    has pyenv && pyenv update
    has code && install-vs-code
    has pnpm && install-pnpm
    has mkcert && install-mkcert
    [[ -d "$XDG_DATA_HOME/NuGet/plugins" ]] && install-nuget-credential-provider
}

update-tools-sudo()
{
    has git-credential-manager-core && install-git-credential-manager
    has zoom && install-zoom
    has task && install-task
}
