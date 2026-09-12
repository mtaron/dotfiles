
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

update-tools()
{
    zgenom selfupdate
    has chezmoi && chezmoi upgrade
}
