#!/bin/sh
xdgSet() {
  xdg-settings set "${1}" "${2}"
}

xdgSet default-web-browser firefox-developer-edition.desktop
