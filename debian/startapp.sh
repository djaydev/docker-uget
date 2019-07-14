#!/bin/sh
export HOME=/config
if [ "$THEME" = "light" ]; then
BREEZE=Breeze
fi
if [ "$THEME" = "dark" ]; then
BREEZE=Breeze-Dark
fi
GTK_THEME=$BREEZE uget-gtk
