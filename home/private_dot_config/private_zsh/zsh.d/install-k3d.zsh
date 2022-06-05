
# Installs the latest k3d using the GitHub CLI
# https://github.com/k3d-io/k3d/

install-k3d()
{
    tmp_dir=$(mktemp -d)
    gh release download --repo k3d-io/k3d --pattern k3d-linux-amd64 --dir "$tmp_dir"
    chmod +x "$tmp_dir/k3d-linux-amd64"
    mv -f "$tmp_dir/k3d-linux-amd64" "$XDG_BIN_DIR/k3d"
    rm -rf "$tmp_dir"
}
