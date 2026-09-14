#!/bin/bash

opt_dir="/opt"
install_dir="$opt_dir/helium"
executable_path="$install_dir/helium"
icon_path="$install_dir/product_logo_256.png"
desktop_file="/usr/share/applications/helium.desktop"

cd $opt_dir 
rm -rf $install_dir
mkdir $install_dir
cd $install_dir

if [[ ! -z $1 ]]; then
    url=$1
else
	url="$(curl -s https://api.github.com/repos/imputnet/helium-linux/releases/latest | jq -r '.assets[] | select(.name | test("helium-.*-x86_64_linux\\.tar\\.xz$")) | .browser_download_url')"
fi
	
curl -L "$url" | tar xJvf - --strip-components=1
sudo chown -R root:root $install_dir 

sudo ln -s /opt/google/chrome/WidevineCdm $install_dir/

rm -f $desktop_file
touch $desktop_file
echo "
[Desktop Entry]
Name=Helium Browser
Comment=Private, fast, and honest web browser 
Keywords=web;browser;internet
Exec=$executable_path %u
Icon=$icon_path
Terminal=false
StartupNotify=true
StartupWMClass=helium
NoDisplay=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
Categories=Network;WebBrowser;
Actions=new-window;new-private-window;
[Desktop Action new-window]
Name=New Window
Exec=$executable_path %u
[Desktop Action new-private-window]
Name=New Incognito Window
Exec=$executable_path --incognito %u
" >> $desktop_file
