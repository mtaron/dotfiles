#!/bin/sh -eu

echo "Installing/updating mise-managed tools..."
~/.local/bin/mise install --locked

# run_onchange hash: {{ include "private_dot_config/mise/mise.lock" | sha256sum }}
