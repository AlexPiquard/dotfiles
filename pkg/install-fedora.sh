#!/bin/bash

set -euo pipefail
cd "$(dirname "$0")"

sudo dnf copr enable -y dejan/lazygit
sudo dnf copr enable -y jdxcode/mise

sudo dnf install -y \
  fzf \
  mise \
  lazygit \
  make \
  neovim \
  ripgrep \
  fd-find \
  stow \
  direnv \
  zsh-autosuggestions \
  maven \
  zsh-syntax-highlighting \
  starship \
  zoxide \
  tree-sitter-cli \
