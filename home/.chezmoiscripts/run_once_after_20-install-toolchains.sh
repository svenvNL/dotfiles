#!/bin/bash
# One-time installers for tools that manage their own install/updates and so can't be
# a chezmoi external (Oh My Zsh and uv are externals, see .chezmoiexternal.toml).
# Each step is skipped when the tool is already present.
set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if ! command -v rustup >/dev/null; then
    echo "==> Installing rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

if ! command -v claude >/dev/null; then
    echo "==> Installing Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
fi

if [ ! -x "$HOME/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox" ]; then
    echo "==> Installing JetBrains Toolbox"
    tmp="$(mktemp -d)"
    curl -fsSL 'https://data.services.jetbrains.com/products/download?platform=linux&code=TBA' -o "$tmp/toolbox.tar.gz"
    tar -xzf "$tmp/toolbox.tar.gz" -C "$tmp"
    # First launch installs itself into ~/.local/share/JetBrains/Toolbox
    nohup "$(find "$tmp" -type f -name jetbrains-toolbox -perm -u+x | head -1)" >/dev/null 2>&1 &
fi
