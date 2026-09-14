#!/bin/bash

theme="$1"
if [ ! $theme ]; then
    theme="'prefer-dark'"
fi

UPDATE_SCRIPT=~/.config/terminal-system-theme/update-theme.sh

# tmux
$UPDATE_SCRIPT "$theme" "tmux/%s.tmux"
tmux source ~/.config/tmux/theme.tmux

# lazygit
$UPDATE_SCRIPT "$theme" "lazygit/%s.yml"

# kitty
$UPDATE_SCRIPT "$theme" "kitty/%s.conf"
kill -SIGUSR1 $(pgrep kitty)

# alacritty
$UPDATE_SCRIPT "$theme" "alacritty/%s.toml"
touch --no-dereference ~/.config/alacritty/alacritty.toml

# fzf
$UPDATE_SCRIPT "$theme" "fzf/%s.sh"
