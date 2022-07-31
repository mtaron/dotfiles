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
}

# https://helm.sh/docs/intro/install/#from-script
install-helm()
{
    HELM_INSTALL_DIR=$XDG_BIN_DIR get-helm-3 --no-sudo
}

# https://github.com/GitCredentialManager/git-credential-manager#download-and-install
install-git-credential-manager()
{
    tmp_dir=$(mktemp --directory)
    gh release download \
        --repo GitCredentialManager/git-credential-manager \
        --pattern 'gcm-linux_amd*.deb' \
        --dir "$tmp_dir"
    sudo dpkg --install gcm-linux_amd*.deb
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
    curl --show-error --silent --fail --location https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

    ln --symbolic --force "$PYENV_ROOT/bin/pyenv" "$XDG_BIN_DIR/pyenv"
}

# https://sw.kovidgoyal.net/kitty/binary/#install-kitty
install-kitty()
{
    destination="$XDG_DATA_HOME"/kitty

    rm --recursive --force "$destination"

    tmp_dir=$(mktemp --directory)

    gh release download \
        --repo kovidgoyal/kitty \
        --pattern 'kitty*x86_64.txz' \
        --dir "$tmp_dir"

    mkdir "$destination"
    tar --extract --xz \
        --directory "$destination" \
        --file "$tmp_dir"/*x86_64.txz

    rm --recursive --force "$tmp_dir"

    ln --symbolic --force "$destination"/bin/kitty "$XDG_BIN_DIR"/kitty
}
