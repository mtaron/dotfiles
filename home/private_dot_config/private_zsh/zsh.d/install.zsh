# Downloads VS Code in Portable Mode
# https://code.visualstudio.com/docs/editor/portable
# This has the advantage of a clean home directory and apt update of code seems hit or miss anyways.
install-vs-code()
{
    local code_dir="$XDG_DATA_HOME/vscode"

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
    code --update-extensions
}

# https://helm.sh/docs/intro/install/#from-script
install-helm()
{
    HELM_INSTALL_DIR="$XDG_BIN_DIR" get-helm-3 --no-sudo
    helm version
}

# https://github.com/git-ecosystem/git-credential-manager/blob/release/docs/install.md#linux
install-git-credential-manager()
{
    local tmp_dir=$(mktemp --directory)
    gh release download \
        --repo git-ecosystem/git-credential-manager \
        --pattern 'gcm-linux_amd64.*.deb' \
        --dir "$tmp_dir"
    sudo dpkg --install "$tmp_dir"/gcm-linux_amd64.*.deb
    rm -rf "$tmp_dir"

    git-credential-manager configure
}

# https://github.com/protocolbuffers/protobuf
install-protobuf-compiler()
{
    local install_path="$XDG_DATA_HOME"/protoc
    rm -rf "$install_path"

    local tmp_dir=$(mktemp --directory)
    gh release download \
        --repo protocolbuffers/protobuf \
        --pattern 'protoc-*-linux-x86_64.zip' \
        --dir "$tmp_dir"
    unzip -q -d "$install_path" "$tmp_dir"/protoc-*-linux-x86_64.zip

    ln --symbolic --force "$install_path/bin/protoc" "$XDG_BIN_DIR/protoc"

    rm -rf "$tmp_dir"
}

# https://github.com/kubernetes-sigs/kustomize
install-kustomize()
{
    rm --force "$XDG_BIN_DIR"/kustomize

    local tmp_dir=$(mktemp --directory)
    gh release download \
        --repo kubernetes-sigs/kustomize \
        --pattern 'kustomize_v*_linux_amd64.tar.gz' \
        --dir "$tmp_dir"
    tar --extract --ungzip --file "$tmp_dir"/kustomize_v*_linux_amd64.tar.gz --directory "$XDG_BIN_DIR"

    rm -rf "$tmp_dir"

    kustomize version
}

# https://github.com/microsoft/artifacts-credprovider#installation-on-linux-and-mac
install-nuget-credential-provider()
{
    local plugin_path="$XDG_DATA_HOME/NuGet/plugins"
    local uri="https://github.com/Microsoft/artifacts-credprovider/releases/latest/download/Microsoft.Net6.NuGet.CredentialProvider.tar.gz"

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

# https://github.com/Azure/azure-functions-core-tools
# Needed this because the package feed was not updated quickly enough
install-azure-function-tools()
{
    local install_path="$XDG_DATA_HOME"/azure-functions-core-tools
    rm -rf "$install_path"

    local tmp_dir=$(mktemp --directory)

    gh release download \
        --repo Azure/azure-functions-core-tools \
        --pattern 'Azure.Functions.Cli.linux-x64.*.zip' \
        --dir "$tmp_dir"

    unzip -q -d "$install_path" "$tmp_dir"/Azure.Functions.Cli.linux-x64.*.zip
    chmod u+x "$install_path"/func
    chmod u+x "$install_path"/gozip

    ln --symbolic --force "$install_path/func" "$XDG_BIN_DIR/func"
    ln --symbolic --force "$install_path/gozip" "$XDG_BIN_DIR/gozip"

    rm -rf "$tmp_dir"
}

install-go()
{
    rm -rf "$XDG_DATA_HOME/go"

    local go_version=1.22

    local latest=$(curl --show-error --silent --fail "https://go.dev/dl/?mode=json" \
        | jq --arg version "go$go_version" -r '.[] | select(.stable == true) | .version | select(startswith($version))')

    curl --show-error --silent --fail --location "https://go.dev/dl/$latest.linux-amd64.tar.gz" \
            --header "Accept: application/octet-stream" \
            | tar --extract --ungzip --directory "$XDG_DATA_HOME"

    ln --symbolic --force "$XDG_DATA_HOME/go/bin/go" "$XDG_BIN_DIR/go"
    ln --symbolic --force "$XDG_DATA_HOME/go/bin/gofmt" "$XDG_BIN_DIR/gofmt"

    go version
}

# https://support.zoom.us/hc/en-us/articles/204206269-Installing-or-updating-Zoom-on-Linux
install-zoom()
{
    local tmp_dir=$(mktemp --directory)
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
    has pyenv && pyenv update
    has code && install-vs-code
    has go && install-go
    has func && install-azure-function-tools
    has protoc && install-protobuf-compiler
    has kustomize && install-kustomize
    has az && az bicep upgrade
    has pipx && pipx upgrade-all
    [[ -d "$XDG_DATA_HOME/NuGet/plugins" ]] && install-nuget-credential-provider
}

update-tools-sudo()
{
    has snap && sudo snap refresh
    has git-credential-manager && install-git-credential-manager
    has zoom && install-zoom
}
