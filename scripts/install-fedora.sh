#!/bin/bash

set -euo pipefail
cd "$(dirname "$0")"

sudo dnf copr enable -y dejan/lazygit
sudo dnf copr enable -y jdxcode/mise

sudo dnf install -y \
  fzf \
  mise \
  make \
  neovim \
  ripgrep \
  fd-find \
  stow \
  maven \
  starship \
  zoxide \
  tree-sitter-cli \
  eza \
  1password \
  1password-cli
