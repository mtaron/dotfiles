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
    ln -sf "$code_dir/bin/code" "$XDG_BIN_DIR/code"

    # Create a symbolic link for zsh completions
    ln -sf "$code_dir/resources/completions/zsh/_code" "$ZDOTDIR/completions/_code"
}

# Installs the latest k3d using the GitHub CLI
# https://github.com/k3d-io/k3d/
install-k3d()
{
    tmp_dir=$(mktemp -d)
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
    tmp_dir=$(mktemp -d)
    gh release download \
        --repo GitCredentialManager/git-credential-manager \
        --pattern 'gcm-linux_amd*.deb' \
        --dir "$tmp_dir"
    sudo dpkg --install gcm-linux_amd*.deb
    git-credential-manager-core configure
    rm -rf "$tmp_dir"
}
