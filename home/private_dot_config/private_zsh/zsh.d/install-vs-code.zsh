
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
    ln -s "$code_dir/bin/code" "$XDG_BIN_DIR/code"
}
