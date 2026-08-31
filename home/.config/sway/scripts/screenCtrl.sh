#!/bin/sh
keyword="${1}"
screens=$(swaymsg -t get_outputs | jq -r '.[] .name')
case "${keyword}" in
off | disable)
  for screen in ${screens}; do
    swaymsg output "${screen}" disable
  done
  ;;
on | enable)
  for screen in ${screens}; do
    swaymsg output "${screen}" enable
  done
  ;;
*)
  echo "invalid usage"
  echo "$0 [keyword]\nkeyword is any of the following: on, enable, off, disable"
  ;;
esac
