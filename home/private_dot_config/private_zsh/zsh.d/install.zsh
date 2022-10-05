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
        | tar --extract --ungzip --directory "$XDG_DATA_HOME" --transform s/VSCode-linux-x64/vscode/

    # Create a symbolic link to add code to the path
    ln --symbolic --force "$code_dir/bin/code" "$XDG_BIN_DIR/code"

    # Create a symbolic link for zsh completions
    ln --symbolic --force "$code_dir/resources/completions/zsh/_code" "$ZDOTDIR/completions/_code"

    code --version
}

# Installs the latest k3d using the GitHub CLI
# https://github.com/k3d-io/k3d/
install-k3d()
{
    tmp_dir=$(mktemp --directory)
    gh release download --repo k3d-io/k3d --pattern k3d-linux-amd64 --dir "$tmp_dir"
    chmod 700 "$tmp_dir/k3d-linux-amd64"
    mv -f "$tmp_dir/k3d-linux-amd64" "$XDG_BIN_DIR/k3d"
    rm -rf "$tmp_dir"

    k3d --version
}

# https://helm.sh/docs/intro/install/#from-script
install-helm()
{
    HELM_INSTALL_DIR=$XDG_BIN_DIR get-helm-3 --no-sudo

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
    gh release download \
        --repo Azure/kubelogin \
        --pattern 'kubelogin-linux-amd64.zip' \
        --dir "$tmp_dir"
    unzip -j -d "$XDG_BIN_DIR" "$tmp_dir"/kubelogin-linux-amd64.zip
    rm -rf "$tmp_dir"
}

install-pulumi()
{
    rm --force "$XDG_BIN_DIR"/pulumi*

    tmp_dir=$(mktemp --directory)
    gh release download \
        --repo pulumi/pulumi \
        --pattern 'pulumi-*-linux-x64.tar.gz' \
        --dir "$tmp_dir"
    tar --extract --ungzip --directory "$XDG_BIN_DIR" --strip-components=1 --file "$tmp_dir"/pulumi-*-linux-x64.tar.gz
    rm -rf "$tmp_dir"
}

install-task()
{
    task_dir="$XDG_DATA_HOME/task"

    # Remove old install
    rm -rf "$task_dir"

    mkdir "$task_dir"

    tmp_dir=$(mktemp --directory)
    gh release download \
        --repo go-task/task \
        --pattern 'task_linux_amd64.tar.gz' \
        --dir "$tmp_dir"
    tar --extract --ungzip --directory "$task_dir" --file "$tmp_dir"/task_linux_amd64.tar.gz

    # Create a symbolic link to add task to the path
    ln --symbolic --force "$task_dir/task" "$XDG_BIN_DIR/task"

    # Create a symbolic link for zsh completions
    ln --symbolic --force "$task_dir/completion/zsh/_task" "$ZDOTDIR/completions/_task"

    rm -rf "$tmp_dir"

    task --version
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

update-tools()
{
    zgenom selfupdate
    has azcopy && install-azcopy
    has chezmoi && chezmoi upgrade
    has helm && install-helm
    has k3d && install-k3d
    has kubelogin && install-kubelogin
    has pulumi && install-pulumi
    has pyenv && install-pyenv
    has code && install-vs-code
    has task && install-task
    [[ -d "$XDG_DATA_HOME/NuGet/plugins" ]] && install-nuget-credential-provider
}

update-tools-sudo()
{
    has git-credential-manager-core && install-git-credential-manager
    has zoom && install-zoom
}
