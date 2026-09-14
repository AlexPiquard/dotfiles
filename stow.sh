#!/bin/bash

stow .

if [[ "$XDG_CURRENT_DESKTOP" == *"Hyprland"* ]]; then
    stow hypr
elif [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
    stow gnome
fi
