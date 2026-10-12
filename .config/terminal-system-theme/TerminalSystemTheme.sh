#!/bin/bash

last=""

gdbus monitor --session \
	--dest org.freedesktop.portal.Desktop \
	--object-path /org/freedesktop/portal/desktop |
	while read -r line; do
		if [[ "$line" == *"SettingChanged ('org.gnome.desktop.interface', 'color-scheme'"* ]]; then
			theme="$(printf '%s\n' "$line" | sed -E "s/.*color-scheme', <'?([^'>]*)'?>.*/\1/")"

			if [ "$theme" != "$last" ]; then
				last="$theme"
				~/.config/terminal-system-theme/update-themes.sh "$theme"
			fi
		fi
	done
