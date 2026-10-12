#!/bin/bash

theme="$1"
if [ -z "$theme" ]; then
    theme="prefer-dark"
fi

UPDATE_SCRIPT=~/.config/terminal-system-theme/update-theme.sh

# tmux
$UPDATE_SCRIPT "$theme" "tmux/%s.tmux"
tmux source ~/.config/tmux/theme.tmux

# kitty
$UPDATE_SCRIPT "$theme" "kitty/%s.conf"
pids=$(pgrep kitty)
if [ -n  "$pids" ]; then
    kill -SIGUSR1 $pids
fi

# alacritty
$UPDATE_SCRIPT "$theme" "alacritty/%s.toml"
touch --no-dereference ~/.config/alacritty/alacritty.toml

# fzf
$UPDATE_SCRIPT "$theme" "fzf/%s.sh"

# eza
$UPDATE_SCRIPT "$theme" "eza/%s.yml"
