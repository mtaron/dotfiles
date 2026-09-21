#!/usr/bin/env bash

set -euo pipefail

sudo tee /etc/sysctl.d/99-local.conf > /dev/null <<'EOF'
fs.inotify.max_user_instances=1024
fs.inotify.max_user_watches=524288
fs.file-max=2097152
EOF

sudo sysctl --system
