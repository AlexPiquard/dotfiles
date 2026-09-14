#!/bin/bash

interface="org.freedesktop.portal.Settings"
monitor_path="/org/freedesktop/portal/desktop"
monitor_member="SettingChanged"
count=0 #D-Bus fires the change event 4 times so we'll only act on it once

dbus-monitor --profile "interface='$interface',path=$monitor_path,member=$monitor_member" |
	while read line; do
		let count++

		if [ $count = 3 ]; then
			theme="$(dconf read /org/gnome/desktop/interface/color-scheme)"

			~/.config/terminal-system-theme/update-themes.sh "$theme"
			count=0
		fi
	done
