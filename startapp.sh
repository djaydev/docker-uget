#!/bin/sh
export HOME=/config
if [ "$THEME" = "light" ]; then
mkdir -p /config/xdg/config/gtk-3.0
printf "[Settings]\ngtk-application-prefer-dark-theme=0" > /config/xdg/config/gtk-3.0/settings.ini
sed -i "/launch/s/true/false/g" /config/xdg/config/uGet/Setting.json
aria2c --enable-rpc=true -D --disable-ipv6 --check-certificate=false
uget-gtk
fi
if [ "$THEME" = "dark" ]; then
mkdir -p /config/xdg/config/gtk-3.0
printf "[Settings]\ngtk-application-prefer-dark-theme=1" > /config/xdg/config/gtk-3.0/settings.ini
sed -i "/launch/s/true/false/g" /config/xdg/config/uGet/Setting.json
aria2c --enable-rpc=true -D --disable-ipv6 --check-certificate=false
uget-gtk
fi
