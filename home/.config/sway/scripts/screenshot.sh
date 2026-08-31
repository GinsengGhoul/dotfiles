#!/bin/sh
set -e

sh_exit() {
  echo "Error: This script requires at least two arguments." >&2
  echo "Usage: $0 <action> <file/target> [additional_args...]" >&2
  exit 1
}

if [ "$#" -lt 1 ]; then
  sh_exit
fi

action="$1"
shift

case "${action}" in
area | -a)
  grim -g "$(slurp)" - | wl-copy
  ;;
screen | -s)
  grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" - | wl-copy
  ;;
window | -w)
  grim -g "$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" - | wl-copy
  ;;
*)
  sh_exit
  ;;
esac
