#!/bin/sh

if [ "$1" = "'prefer-dark'" ]; then
  THEME="tokyonight_moon"
else
  THEME="tokyonight_day"
fi

ln -sf "$HOME/.config/$(printf $2 $THEME)" "$HOME/.config/$(printf $2 'theme')"
