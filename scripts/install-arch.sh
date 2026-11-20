#!/bin/bash

set -euo pipefail
cd "$(dirname "$0")"

sudo pacman -Syu --noconfirm fzf \
  mise \
  neovim \
  fd \
  stow \
  maven \
  starship \
  zoxide \
  tree-sitter-cli \
  eza
