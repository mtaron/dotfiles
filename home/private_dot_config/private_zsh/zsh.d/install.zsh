
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

install-go()
{
    rm -rf "$XDG_DATA_HOME/go"

    local go_version=1.27

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

update-tools()
{
    zgenom selfupdate
    has chezmoi && chezmoi upgrade
}

update-tools-sudo()
{
    has snap && sudo snap refresh
    has zoom && install-zoom
}
